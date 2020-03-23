set pages 9999;

column logical_reads  format 999,999,999
column phys_reads     format 999,999,999
column phys_writes    format 999,999,999
column "BUFFER HIT RATIO" format 999

select
   to_char(snap_time,'day'),
   avg(round(100 * (((a.value-b.value))-(c.value-d.value)) / ((e.value-f.value))))
         "BUFFER HIT RATIO"
from 
   perfstat.stats$sysstat a, 
   perfstat.stats$sysstat b, 
   perfstat.stats$sysstat c, 
   perfstat.stats$sysstat d,
   perfstat.stats$sysstat e,
   perfstat.stats$sysstat f,
   perfstat.stats$snapshot   sn
where
   a.snap_id = sn.snap_id
and
   b.snap_id = sn.snap_id
and
   c.snap_id = sn.snap_id
and
   d.snap_id = sn.snap_id
and
   e.snap_id = sn.snap_id-1
and
   f.snap_id = sn.snap_id-1
and
   a.statistic# = 40
and
   b.statistic# = 40
and
   c.statistic# = 86
and
   d.statistic# = 86
and
   e.statistic# = 9
and
   f.statistic# = 9
group by
   to_char(snap_time,'day')
;

