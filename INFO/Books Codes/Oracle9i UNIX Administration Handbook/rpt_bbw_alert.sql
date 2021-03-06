--**************************************************************
--   rpt_bbw_alert.sql
--
--   � 2001 by Donald K. Burleson
--
--   No part of this SQL script may be copied. Sold or distributed
--   without the express consent of Donald K. Burleson
--**************************************************************
set pages 9999;

column buffer_busy_wait format 999,999,999
column mydate heading 'Yr. Mo Dy  Hr.' format a16

select
   to_char(snap_time,'yyyy-mm-dd HH24')           mydate,
   avg(new.buffer_busy_wait-old.buffer_busy_wait) buffer_busy_wait
from
   perfstat.stats$buffer_pool_statistics old,
   perfstat.stats$buffer_pool_statistics new,
   perfstat.stats$snapshot   sn
where
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
and
   new.buffer_busy_wait-old.buffer_busy_wait > 4000
group by
   to_char(snap_time,'yyyy-mm-dd HH24')
;

