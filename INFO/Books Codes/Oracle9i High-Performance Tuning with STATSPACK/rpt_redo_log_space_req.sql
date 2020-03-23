set pages 9999;

column redo_log_space_requests  format 999,999,999

select 
   to_char(snap_time,'yyyy-mm-dd HH24'),
   a.value redo_log_space_requests
from
   perfstat.stats$sysstat     a,
   perfstat.stats$snapshot   sn
where
   a.snap_id = sn.snap_id
and
   a.name = 'redo log space requests'
;
