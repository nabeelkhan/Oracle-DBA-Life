set pages 9999;

column redo_log_space_requests  format 999,999,999

select 
   to_char(snap_time,'yyyy-mm-dd HH24'),
   newmem.value-oldmem.value redo_log_space_requests
from
   perfstat.stats$sysstat oldmem,
   perfstat.stats$sysstat newmem,
   perfstat.stats$snapshot   sn
where
   newmem.snap_id = sn.snap_id
and
   oldmem.snap_id = sn.snap_id-1
and
   oldmem.name = 'redo log space requests'
and
   newmem.name = 'redo log space requests'
and
   newmem.value-oldmem.value > 0
;
