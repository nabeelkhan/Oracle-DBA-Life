set pages 9999;

column current_logons     format 999,999,999
column cumulative_logons  format 999,999,999

select
   to_char(snap_time,'yyyy-mm-dd HH24'),
--   a.value cumulative_logons,
   b.value current_logons
from 
   perfstat.stats$sysstat a, 
   perfstat.stats$sysstat b, 
   perfstat.stats$snapshot   sn
where
   a.snap_id = sn.snap_id
and
   b.snap_id = sn.snap_id
and
   a.statistic# = 0
and
   b.statistic# = 1
;

