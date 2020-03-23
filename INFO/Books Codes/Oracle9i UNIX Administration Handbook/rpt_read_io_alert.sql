set pages 9999;

prompt
prompt
prompt  This will identify any single file who's read I/O
prompt  is more than 20% of the total read I/O of the database.
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
prompt    the table in the RECYCLE pool abd turn on parallel query
prompt    for the table.
prompt
prompt

column mydate format a16
column file_name format a40
column reads  format 999,999,999

select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   new.filename                          file_name,
   new.phyrds-old.phyrds                 reads
from
   perfstat.stats$filestatxs old,
   perfstat.stats$filestatxs new,
   perfstat.stats$snapshot   sn
where
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
and
   new.filename = old.filename
and
   new.phyrds-old.phyrds > 10000
and
   (new.phyrds-old.phyrds)*20 >
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
