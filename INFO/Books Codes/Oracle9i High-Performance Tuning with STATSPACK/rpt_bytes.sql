--*********************************************************
-- First we need to get the second-highest date in tab_stats
--*********************************************************
set lines 80;
set pages 999;
set feedback off;
set verify off;
set echo off;

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

prompt Object growth - Comparing last two snapshots
prompt   
prompt This report shows the growth of key tables 
prompt for the past week.


select 'Old date = '||max(mydate) from d1;
select 'New date = '||max(to_char(snap_time,'YYYY-MM-DD')) from stats$tab_stats;

break on report ; 
compute sum of old_bytes on old.table_name;

set heading on;

column old_bytes format 999,999,999
column new_bytes format 999,999,999
column change    format 999,999,999

select
   new.table_name,
   old.bytes                old_bytes,
   new.bytes                new_bytes,
   new.bytes - old.bytes    change
from
   stats$tab_stats old,
   stats$tab_stats new
where
   old.table_name = new.table_name
and
   new.bytes > old.bytes
and
   new.bytes - old.bytes > 10000
and
   to_char(new.snap_time, 'YYYY-MM-DD') = 
          (select max(to_char(snap_time,'YYYY-MM-DD')) from stats$tab_stats) 
and
   to_char(old.snap_time, 'YYYY-MM-DD') = 
           (select max(mydate) from d1)
and
   new.table_name not like 'STATS$%'
order by
   new.bytes-old.bytes desc
;



--*********************************************************
-- First we need to get the second-highest date in idx_stats
--*********************************************************
set lines 80;
set pages 999;
set feedback off;
set verify off;
set echo off;

drop table d1;

create table d1 as
select distinct
   to_char(snap_time,'YYYY-MM-DD') mydate
from
   stats$idx_stats
where
   to_char(snap_time,'YYYY-MM-DD') <
    (select max(to_char(snap_time,'YYYY-MM-DD')) from stats$idx_stats)
;

--*********************************************************
-- The second highest date is select max(mydate) from d1;
--*********************************************************

set heading off;

prompt Object growth - Comparing last two snapshots
prompt   
prompt This report shows the growth of key indexes 
prompt for the past week.


select 'Old date = '||max(mydate) from d1;
select 'New date = '||max(to_char(snap_time,'YYYY-MM-DD')) from stats$idx_stats;

break on report ; 
compute sum of old_bytes on old.table_name;

set heading on;

column old_bytes format 999,999,999
column new_bytes format 999,999,999
column change    format 999,999,999

select
   new.index_name,
   old.bytes                old_bytes,
   new.bytes                new_bytes,
   new.bytes - old.bytes    change
from
   stats$idx_stats old,
   stats$idx_stats new
where
   old.index_name = new.index_name
and
   new.bytes > old.bytes
and
   new.bytes - old.bytes > 10000
and
   to_char(new.snap_time, 'YYYY-MM-DD') = 
          (select max(to_char(snap_time,'YYYY-MM-DD')) from stats$idx_stats) 
and
   to_char(old.snap_time, 'YYYY-MM-DD') = 
           (select max(mydate) from d1)
and
   new.index_name not like 'STATS$%'
order by
   new.bytes-old.bytes desc
;
