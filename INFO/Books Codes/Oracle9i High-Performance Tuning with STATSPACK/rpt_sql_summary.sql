set pages 9999;

column sorts_memory  format 999,999,999
column sorts_disk    format 999,999,999
column ratio format .99999

select 
   to_char(snap_time,'yyyy-mm-dd HH24'),
   sum(disk_reads) disk_reads,
   sum(buffer_gets) buffer_gets,
   (sum(disk_reads)/sum(buffer_gets)) ratio
from
   perfstat.stats$sql_summary  a,
   perfstat.stats$snapshot   sn
where
   a.snap_id = sn.snap_id
group by
   to_char(snap_time,'yyyy-mm-dd HH24')
;
