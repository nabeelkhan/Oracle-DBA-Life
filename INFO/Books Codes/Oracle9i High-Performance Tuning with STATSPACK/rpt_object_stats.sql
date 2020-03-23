--**************************************************************
--   rpt_object_stats.sql
--
--   © 2001 by Donald K. Burleson
--
--   No part of this SQL script may be copied. Sold or distributed
--   without the express consent of Donald K. Burleson
--**************************************************************
connect perfstat/perfstat;

set lines 80;
set pages 999;
set feedback off;
set verify off;
set echo off;

--*********************************************************
-- This report compares the max(snap_time) to the second-highest date
--*********************************************************

--*********************************************************
-- First we need to get the second-highest date in tab_stats
--*********************************************************
drop table d1;

create table d1 as
select distinct 
   to_char(snap_time,'YYYY-MM-DD') mydate
from
   stats$tab_stats
where 
   to_char(snap_time,'YYYY-MM-DD') <
    (select max(to_char(snap_time,'YYYY-MM-DD')) from stats$tab_stats)
;

--*********************************************************
-- The second highest date is select max(mydate) from d1;
--*********************************************************

set heading off;

prompt '*********************************************'
select '  Most recent date '||
          max(to_char(snap_time,'YYYY-MM-DD')) 
from stats$tab_stats;
select '  Older date '||
          max(mydate)
from d1;
prompt '*********************************************'

set heading on;

drop table t1;
drop table t2;
drop table t3;
drop table t4;

 
create table t1 as
select db_name, count(*) tab_count, snap_time from stats$tab_stats 
where    to_char(snap_time, 'YYYY-MM-DD') = 
           (select max(to_char(snap_time,'YYYY-MM-DD')) from stats$tab_stats) 
group by db_name, snap_time;
 
create table t2 as
select db_name, count(*) idx_count, snap_time from stats$idx_stats 
where    to_char(snap_time, 'YYYY-MM-DD') = 
           (select max(to_char(snap_time,'YYYY-MM-DD')) from stats$idx_stats) 
group by db_name, snap_time;
 
create table t3 as
select db_name, sum(bytes) tab_bytes, snap_time from stats$tab_stats 
where    to_char(snap_time, 'YYYY-MM-DD') = 
           (select max(to_char(snap_time,'YYYY-MM-DD')) from stats$tab_stats) 
group by db_name, snap_time;
 
create table t4 as
select db_name, sum(bytes) idx_bytes, snap_time from stats$idx_stats
where    to_char(snap_time, 'YYYY-MM-DD') = 
           (select max(to_char(snap_time,'YYYY-MM-DD')) from stats$idx_stats) 
group by db_name, snap_time;

--*********************************************************
-- This report displays the most recent counts & size totals
--*********************************************************

column tab_bytes format 999,999,999,999
column idx_bytes format 999,999,999,999
column tab_count format 99,999
column idx_count format 99,999

clear computes;
compute sum label "Total" of tab_count on report;
compute sum label "Total" of idx_count on report;
compute sum label "Total" of tab_bytes on report;
compute sum label "Total" of idx_bytes on report;

break on report;

ttitle 'Most recent database object counts and sizes' 

select 
   a.db_name, 
   tab_count,
   idx_count,
   tab_bytes,
   idx_bytes
from
   perfstat.t1 a,
   perfstat.t2 b,
   perfstat.t3 c,
   perfstat.t4 d
where
   a.db_name = b.db_name
and
   a.db_name = c.db_name
and
   a.db_name = d.db_name
;



--*********************************************************
-- These temp tables will compare size growth since last snap
--*********************************************************
drop table t1;
drop table t2;
drop table t3;
drop table t4;

create table t1 as
select db_name, sum(bytes) new_tab_bytes, snap_time from stats$tab_stats 
where    to_char(snap_time, 'YYYY-MM-DD') = 
           (select max(to_char(snap_time,'YYYY-MM-DD')) from stats$tab_stats) 
group by db_name, snap_time;
 
create table t2 as
select db_name, sum(bytes) new_idx_bytes, snap_time from stats$idx_stats
where    to_char(snap_time, 'YYYY-MM-DD') = 
           (select max(to_char(snap_time,'YYYY-MM-DD')) from stats$idx_stats) 
group by db_name, snap_time;
 
create table t3 as
select db_name, sum(bytes) old_tab_bytes, snap_time from stats$tab_stats
where    to_char(snap_time, 'YYYY-MM-DD') = 
           (select max(mydate) from d1) 
group by db_name, snap_time;
 
create table t4 as
select db_name, sum(bytes) old_idx_bytes, snap_time from stats$idx_stats
where    to_char(snap_time, 'YYYY-MM-DD') = 
           (select max(mydate) from d1) 
group by db_name, snap_time;



--*********************************************************
-- This is the size comparison report
--*********************************************************
column old_bytes format 999,999,999,999
column new_bytes format 999,999,999,999
column change    format 999,999,999,999

compute sum label "Total" of old_bytes on report;
compute sum label "Total" of new_bytes on report;
compute sum label "Total" of change    on report;

break on report;
ttitle 'Database size change|comparing the most recent snapshot dates';
 

select 
   a.db_name, 
   old_tab_bytes+old_idx_bytes old_bytes,
   new_tab_bytes+new_idx_bytes new_bytes,
   (new_tab_bytes+new_idx_bytes)-(old_tab_bytes+old_idx_bytes) change
from
   perfstat.t1 a,
   perfstat.t2 b,
   perfstat.t3 c,
   perfstat.t4 d
where
   a.db_name = b.db_name
and
   a.db_name = c.db_name
and
   a.db_name = d.db_name
;



--*********************************************************
-- This is the standard chained row report
-- 
-- This is for columns without long columns
-- because long columns often chain onto adjacent data blocks
--*********************************************************

column c1 heading "Owner"   format a9;
column c2 heading "Table"   format a12;
column c3 heading "PCTFREE" format 99;
column c4 heading "PCTUSED" format 99;
column c5 heading "avg row" format 99,999;
column c6 heading "Rows"    format 999,999,999;
column c7 heading "Chains"  format 999,999,999;
column c8 heading "Pct"     format .99;

set heading off;
select 'Tables with > 10% chained rows and no LONG columns.' from dual;
set heading on;

select 
   owner              c1, 
   table_name         c2, 
   pct_free           c3, 
   pct_used           c4, 
   avg_row_len        c5, 
   num_rows           c6, 
   chain_cnt          c7,
   chain_cnt/num_rows c8
from 
   dba_tables
where
   owner not in ('SYS','SYSTEM','PERFSTAT')
and 
   chain_cnt/num_rows > .1
and
table_name not in
 (select table_name from dba_tab_columns
   where
 data_type in ('RAW','LONG RAW','CLOB','BLOB')
 )
and
chain_cnt > 0
order by chain_cnt desc
;

--*********************************************************
-- This chained row report is for tables that have long
-- columns.  The only fix for this chaining is increasing
-- the db_block_size
--*********************************************************
set heading off;
select 'Tables with > 10% chained rows that contain LONG columns.' from dual;
set heading on;

select
   owner              c1,
   table_name         c2,
   pct_free           c3,
   pct_used           c4,
   avg_row_len        c5,   
   num_rows           c6,
   chain_cnt          c7,
   chain_cnt/num_rows c8
from 
   dba_tables
where
   owner not in ('SYS','SYSTEM','PERFSTAT')
and 
   chain_cnt/num_rows > .1
and
table_name in
 (select table_name from dba_tab_columns
   where
 data_type in ('RAW','LONG RAW','CLOB','BLOB')
 )
and
chain_cnt > 0
order by chain_cnt desc
;
 
--*********************************************************
-- This report will show all objects that have extended 
-- between the snapshot period.
-- The DBA may want to increase the next_extent size
-- for these objects
--*********************************************************
column db format a10
column owner format a10
column tab_name format a30

break on db;


ttitle 'Table extents report|Where extents > 200 or table extent changed|comparing most recent snapshots'

select /*+ first_rows */
distinct
   a.db_name     db,
   a.owner       owner, 
   a.table_name  tab_name, 
   b.extents     old_ext,
   a.extents     new_ext
from
   PERFSTAT.stats$tab_stats a,
   PERFSTAT.stats$tab_stats b 
where
   a.db_name = b.db_name
and
   a.owner = b.owner
and
   a.table_name = b.table_name
and
(
   b.extents > a.extents
   or
   a.extents > b.extents
   or
   a.extents > 200
)
and 
   a.owner not in ('SYS','SYSTEM','PERFSTAT')
and 
   a.table_name not in ('PLAN_TABLE')
and
   to_char(a.snap_time, 'YYYY-MM-DD') = 
           (select max(to_char(snap_time,'YYYY-MM-DD')) from stats$tab_stats) 
and
   to_char(b.snap_time, 'YYYY-MM-DD') = 
           (select max(mydate) from d1)
order by
   a.db_name,
   a.extents
;

column db format a10
column owner format a10
column idx_name format a30

break on db;


ttitle 'Index extents report|Where extents > 200 or index extent changed|Comparing last two snapshots'

select /*+ first_rows */
distinct
   a.db_name     db,
   a.owner       owner, 
   a.index_name  idx_name, 
   b.extents     old_ext,
   a.extents     new_ext
from
   PERFSTAT.stats$idx_stats a,
   PERFSTAT.stats$idx_stats b 
where
   a.owner not in ('SYS','SYSTEM','PERFSTAT')
and
   a.db_name = b.db_name
and
   a.owner = b.owner
and
   a.index_name = b.index_name
and
(
   b.extents > a.extents
   or
   a.extents > b.extents
   or
   a.extents > 200
)
and
   to_char(a.snap_time, 'YYYY-MM-DD') = 
           (select max(to_char(snap_time,'YYYY-MM-DD')) from stats$idx_stats) 
and
   to_char(b.snap_time, 'YYYY-MM-DD') = 
           (select max(mydate) from d1)
order by
   a.db_name,
   a.extents
;
