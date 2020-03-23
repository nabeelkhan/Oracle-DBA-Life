set pages 9999;
set feedback off;
set verify off;

column mydate heading 'Yr.  Mo Dy  Hr.' format a16
column file_name format a35
column reads  format 99,999,999
column pct_of_tot  format 999


prompt
prompt
prompt ***********************************************************
prompt  This will identify any single file who's read I/O
prompt  is more than 25% of the total read I/O of the database.
prompt
prompt  The "hot" file should be examined, and the hot table/index
prompt  should be identified using STATSPACK.
prompt
prompt  - The busy file should be placed on a disk device with
prompt    "less busy" files to minimize read delay and channel
prompt    contention.
prompt
prompt  - If small file has a hot small table, place the table
prompt    in the KEEP pool
prompt
prompt  - If the file has a large-table full-table scan, place
prompt    the table in the RECYCLE pool and turn on parallel query
prompt    for the table.
prompt ***********************************************************
prompt
prompt


select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   new.filename                          file_name,
   new.phyrds-old.phyrds                 reads,
   ((new.phyrds-old.phyrds)/
   (
   select
      (newreads.value-oldreads.value) reads
   from
      perfstat.stats$sysstat oldreads,
      perfstat.stats$sysstat newreads,
      perfstat.stats$snapshot   sn1
   where
      sn.snap_id = sn1.snap_id
   and
      newreads.snap_id = sn.snap_id
   and
      oldreads.snap_id = sn.snap_id-1
   and
     oldreads.statistic# = 40
   and
     newreads.statistic# = 40
   and
     (newreads.value-oldreads.value) > 0
   ))*100 pct_of_tot
from
   perfstat.stats$filestatxs old,
   perfstat.stats$filestatxs new,
   perfstat.stats$snapshot   sn
where
   snap_time > sysdate-&1
and
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
and
   new.filename = old.filename
and
   -- ********************************************************** 
   -- Low I/O values are misleading, so we filter for high I/O
   -- ********************************************************** 
   new.phyrds-old.phyrds > 100
and
-- ********************************************************** 
-- The following will allow you to choose a threshold
-- ********************************************************** 
 (new.phyrds-old.phyrds)*4>  -- This is 25% of total
-- (new.phyrds-old.phyrds)*2> -- This is 50% of total
-- (new.phyrds-old.phyrds)*1.25> -- This is 75% of total
-- ********************************************************** 
-- This subquery computes the sum of all I/O during the snapshot period
-- ********************************************************** 
(
select
   (newreads.value-oldreads.value) reads
from
   perfstat.stats$sysstat oldreads,
   perfstat.stats$sysstat newreads,
   perfstat.stats$snapshot   sn1
where
   sn.snap_id = sn1.snap_id
and
   newreads.snap_id = sn.snap_id
and
   oldreads.snap_id = sn.snap_id-1
and
  oldreads.statistic# = 40
and 
  newreads.statistic# = 40
and
  (newreads.value-oldreads.value) > 0
)
;


prompt
prompt
prompt ***********************************************************
prompt  This will identify any single file who's write I/O
prompt  is more than 25% of the total write I/O of the database.
prompt
prompt  The "hot" file should be examined, and the hot table/index
prompt  should be identified using STATSPACK.
prompt
prompt  - The busy file should be placed on a disk device with
prompt    "less busy" files to minimize write delay and channel
prompt    channel contention.
prompt
prompt  - If small file has a hot small table, place the table
prompt    in the KEEP pool
prompt
prompt ***********************************************************
prompt




select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   new.filename                          file_name,
   new.phywrts-old.phywrts               writes,
  ((new.phywrts-old.phywrts)/
   (
   select
      (newwrites.value-oldwrites.value) writes
   from
      perfstat.stats$sysstat   oldwrites,
      perfstat.stats$sysstat   newwrites,
      perfstat.stats$snapshot  sn1
   where
      sn.snap_id = sn1.snap_id
   and
      newwrites.snap_id = sn.snap_id
   and
      oldwrites.snap_id = sn.snap_id-1
   and
     oldwrites.statistic# = 44
   and
     newwrites.statistic# = 44
   and
     (newwrites.value-oldwrites.value) > 0
   ))*100 pct_of_tot
from
   perfstat.stats$filestatxs old,
   perfstat.stats$filestatxs new,
   perfstat.stats$snapshot   sn
where
   snap_time > sysdate-&1
and
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
and
   new.filename = old.filename
and
   -- ********************************************************** 
   -- Low I/O values are misleading, so we only take high values
   -- ********************************************************** 
   new.phywrts-old.phywrts > 100
and
-- ********************************************************** 
-- Here you can choose a threshold value
-- ********************************************************** 
 (new.phyrds-old.phywrts)*4>  -- This is 25% of total
-- (new.phyrds-old.phywrts)*2> -- This is 50% of total
-- (new.phyrds-old.phywrts)*1.25> -- This is 75% of total
-- ********************************************************** 
-- This subquery computes the sum of all I/O during the snapshot period
-- ********************************************************** 
(
select
   (newwrites.value-oldwrites.value) writes
from
   perfstat.stats$sysstat   oldwrites,
   perfstat.stats$sysstat   newwrites,
   perfstat.stats$snapshot  sn1
where
   sn.snap_id = sn1.snap_id
and
   newwrites.snap_id = sn.snap_id
and
   oldwrites.snap_id = sn.snap_id-1
and
  oldwrites.statistic# = 44
and 
  newwrites.statistic# = 44
and
  (newwrites.value-oldwrites.value) > 0
)
;
