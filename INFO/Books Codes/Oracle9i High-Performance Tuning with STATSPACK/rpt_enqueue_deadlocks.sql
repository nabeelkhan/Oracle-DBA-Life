set pages 9999;

column enqueue_deadlocks     format 999,999,999

select
   to_char(snap_time,'yyyy-mm-dd HH24'),
   a.value enqueue_deadlocks
from 
   perfstat.stats$sysstat     a, 
   perfstat.stats$snapshot   sn
where
   a.snap_id = sn.snap_id
and
   a.statistic# = 24
;

