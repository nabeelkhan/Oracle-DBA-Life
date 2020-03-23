set pages 9999;

prompt
prompt
prompt  This will identify any single file who's read I/O
prompt  is more than 10% of the total read I/O of the database.
Prompt
prompt

column reads  format 999,999,999
column writes format 999,999,999

select 
   to_char(snap_time,'yyyy-mm-dd HH24'),
   new.filename,
   new.phyrds-old.phyrds
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
   new.phyrds-old.phyrds > 0
;
