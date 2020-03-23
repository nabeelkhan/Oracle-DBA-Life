set pages 9999;

column sorts_memory  format 999,999,999
column sorts_disk    format 999,999,999
column ratio format .99999

select 
   to_char(snap_time,'day'),
   sum(a.value) sorts_memory,
   sum(b.value) sorts_disk,
   (sum(b.value)/sum(a.value)) ratio
from
   perfstat.stats$sysstat a,
   perfstat.stats$sysstat b,
   perfstat.stats$snapshot   sn
where
   a.snap_id = sn.snap_id
and
   b.snap_id = sn.snap_id
and
   a.name = 'sorts (memory)'
and
   b.name = 'sorts (disk)'
group by
   to_char(snap_time,'day')
;
