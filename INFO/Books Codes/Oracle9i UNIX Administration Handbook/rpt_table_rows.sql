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

ttitle 'Rovia Object growth|Comparing last two snapshots'

prompt This report shows the growth of key tables within the RovReader

prompt for the past week.

column old_rows format 9,999,999
column new_rows format 9,999,999

select
   new.table_name,
   old.num_rows                old_rows,
   new.num_rows                new_rows,
   new.num_rows - old.num_rows change
from
   stats$tab_stats old,
   stats$tab_stats new
where
   new.num_rows > old.num_rows
and
   old.table_name = new.table_name
and
   to_char(new.snap_time, 'YYYY-MM-DD') = 
           (select max(to_char(snap_time,'YYYY-MM-DD')) from stats$tab_stats) 
and
   to_char(old.snap_time, 'YYYY-MM-DD') = 
           (select max(mydate) from d1)
;
