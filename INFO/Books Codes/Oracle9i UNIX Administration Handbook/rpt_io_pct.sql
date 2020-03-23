set pages 9999;

column physical_reads  format     999,999,999,999,999
column physical_writes format     999,999,999,999
column pct_reads format 999
column mydate heading 'Yr.  Mo Dy  Hr.' format a16

select 
   to_char(snap_time,'yyyy-mm-dd')        mydate,
   sum((newreads.value-oldreads.value))   physical_reads,
   sum((newwrites.value-oldwrites.value)) physical_writes,
   (1-(sum((newwrites.value-oldwrites.value)))/(sum((newreads.value-oldreads.value))))*100 pct_reads
from
   perfstat.stats$sysstat oldreads,
   perfstat.stats$sysstat newreads,
   perfstat.stats$sysstat oldwrites,
   perfstat.stats$sysstat newwrites,
   perfstat.stats$snapshot   sn
where
   newreads.snap_id = sn.snap_id
and
   newwrites.snap_id = sn.snap_id
and
   oldreads.snap_id = sn.snap_id-1
and
   oldwrites.snap_id = sn.snap_id-1
and
  oldreads.statistic# = 40
and 
  newreads.statistic# = 40
and 
  oldwrites.statistic# = 41
and
  newwrites.statistic# = 41
and
   (newreads.value-oldreads.value) > 0
and
   (newwrites.value-oldwrites.value) > 0
group by 
   to_char(snap_time,'yyyy-mm-dd')
;
