--**************************************************************
--   rpt_parallel.sql
--
--   © 2001 by Donald K. Burleson
--
--   No part of this SQL script may be copied. Sold or distributed
--   without the express consent of Donald K. Burleson
--**************************************************************
set pages 9999;

column nbr_pq format 999,999,999
column mydate heading 'yr.  mo dy Hr.'

select 
   to_char(snap_time,'yyyy-mm-dd HH24')      mydate,
   new.value
from
   perfstat.stats$sysstat   old,
   perfstat.stats$sysstat   new,
   perfstat.stats$snapshot  sn
where
   new.name = old.name
and
   new.name = 'queries parallelized'
and
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
and
   new.value > 1
order by
   to_char(snap_time,'yyyy-mm-dd HH24')    
;
