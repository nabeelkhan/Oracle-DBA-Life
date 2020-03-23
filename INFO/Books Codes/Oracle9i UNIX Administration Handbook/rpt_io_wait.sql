set pages 9999;

break on snapdate skip 2

column snapdate format a16
column filename format a40

select 
   to_char(snap_time,'yyyy-mm-dd HH24'),
   old.filename,
   new.wait_count-old.wait_count waits
from
   perfstat.stats$filestatxs old,
   perfstat.stats$filestatxs new,
   perfstat.stats$snapshot   sn
where
   new.snap_id = sn.snap_id
and
   old.filename = new.filename
and
   old.snap_id = sn.snap_id-1
and 
   new.wait_count-old.wait_count > 0
;
