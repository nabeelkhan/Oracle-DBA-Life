set pages 9999;

prompt
prompt
prompt  This will identify any single file who's write I/O
prompt  is more than 25% of the total write I/O of the database.
prompt
prompt  The "hot" file should be examined, and the hot table/index
prompt  should be identified using STATSPACK.
prompt
prompt  - The busy file should be placed on a disk device with
prompt    "less busy" files to minimize write delay and channel
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
column writes  format 999,999,999

select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   new.filename                          file_name,
   new.phywrts-old.phywrts                 writes
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
   new.phywrts-old.phywrts > 10000
and
   (new.phywrts-old.phywrts)*25 >
(
select
   (newwrites.value-oldwrites.value) writes
from
   perfstat.stats$sysstat oldwrites,
   perfstat.stats$sysstat newwrites,
   perfstat.stats$snapshot   sn1
where
   sn.snap_id = sn1.snap_id
and
   newwrites.snap_id = sn.snap_id
and
   oldwrites.snap_id = sn.snap_id-1
and
  oldwrites.statistic# = 40
and 
  newwrites.statistic# = 40
and
  (newwrites.value-oldwrites.value) > 0
)
;
