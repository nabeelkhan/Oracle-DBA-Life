set pages 9999;

column long_table_fts     format 999,999,999

select
   to_char(snap_time,'day'),
   avg(a.value) long_table_fts
from 
   perfstat.stats$sysstat     a, 
   perfstat.stats$snapshot   sn
where
   a.snap_id = sn.snap_id
and
   a.statistic# = 140
group by
   to_char(snap_time,'day')
;

