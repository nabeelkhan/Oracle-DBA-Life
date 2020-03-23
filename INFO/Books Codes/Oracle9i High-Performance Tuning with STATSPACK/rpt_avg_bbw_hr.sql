--**************************************************************
--   rpt_avg_bbw_hr.sql
--
--   © 2001 by Donald K. Burleson
--
--   No part of this SQL script may be copied. Sold or distributed
--   without the express consent of Donald K. Burleson
--**************************************************************
set pages 9999;

column buffer_busy_wait format 999,999,999

select 
   to_char(snap_time,'HH24'),
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
   to_char(snap_time,'HH24')
;
