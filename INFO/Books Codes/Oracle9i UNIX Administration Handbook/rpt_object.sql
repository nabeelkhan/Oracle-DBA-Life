--**************************************************************
--   rpt_object.sql
--
--   © 2001 by Donald K. Burleson
--
--   No part of this SQL script may be copied. Sold or distributed
--   without the express consent of Donald K. Burleson
--**************************************************************
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

--  ******************************************************************
--  Summarize the counts of all tables for the most recent snapshot
--  ******************************************************************

create table t1 as
select db_name, count(*) tab_count, snap_time from stats$tab_stats
where    to_char(snap_time, 'YYYY-MM-DD') =
           (select max(to_char(snap_time,'YYYY-MM-DD')) 
               from stats$tab_stats)
group by db_name, snap_time;

--  *****************************************************************
--  Summarize the counts of all indexes for the most recent snapshot
--  *****************************************************************

create table t2 as
select db_name, count(*) idx_count, snap_time from stats$idx_stats
where    to_char(snap_time, 'YYYY-MM-DD') =
           (select max(to_char(snap_time,'YYYY-MM-DD')) 
                from stats$idx_stats)
group by db_name, snap_time;

--  *****************************************************************
--  Summarize sum of bytes of all tables for the 2nd highest snapshot
--  *****************************************************************

create table t3 as
select db_name, sum(bytes) tab_bytes, snap_time from stats$tab_stats
where    to_char(snap_time, 'YYYY-MM-DD') =
           (select max(to_char(snap_time,'YYYY-MM-DD')) 
                from stats$tab_stats)
group by db_name, snap_time;

--  *****************************************************************
--  Summarize sum of bytes of all indexes for the 2nd highest snapshot
--  *****************************************************************

create table t4 as
select db_name, sum(bytes) idx_bytes, snap_time from stats$idx_stats
where    to_char(snap_time, 'YYYY-MM-DD') =
           (select max(to_char(snap_time,'YYYY-MM-DD')) 
              from stats$idx_stats)
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
   perfstat.t1 a,  -- table counts
   perfstat.t2 b,  -- index counts
   perfstat.t3 c,  -- all table bytes
   perfstat.t4 d   -- all index bytes
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
select db_name, sum(bytes) new_tab_bytes, snap_time 
     from stats$tab_stats
where    to_char(snap_time, 'YYYY-MM-DD') =
           (select max(to_char(snap_time,'YYYY-MM-DD')) 
               from stats$tab_stats)
group by db_name, snap_time;

create table t2 as
select db_name, sum(bytes) new_idx_bytes, snap_time 
      from stats$idx_stats
where    to_char(snap_time, 'YYYY-MM-DD') =
           (select max(to_char(snap_time,'YYYY-MM-DD')) 
               from stats$idx_stats)
group by db_name, snap_time;

create table t3 as
select db_name, sum(bytes) old_tab_bytes, snap_time 
      from stats$tab_stats
where    to_char(snap_time, 'YYYY-MM-DD') =
           (select max(mydate) from d1)
group by db_name, snap_time;

create table t4 as
select db_name, sum(bytes) old_idx_bytes, snap_time 
       from stats$idx_stats
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
ttitle 'Database size change|comparing most recent snapshot dates';


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

