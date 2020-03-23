set pages 9999;

column current_logons     format 999,999,999

select
   to_char(snap_time,'day'),
   avg(a.value) current_logons
from 
   perfstat.stats$sysstat a, 
   perfstat.stats$snapshot   sn
where
   a.snap_id = sn.snap_id
and
   a.statistic# = 1
group by
   to_char(snap_time,'day')
;

