set pages 9999;

column buffer_busy_wait format 999,999,999

select 
   to_char(snap_time,'day'),
   avg(new.buffer_busy_wait-old.buffer_busy_wait) buffer_busy_wait
from
   perfstat.stats$buffer_pool_statistics old,
   perfstat.stats$buffer_pool_statistics new,
   perfstat.stats$snapshot   sn
where
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
group by
   to_char(snap_time,'day')
;
