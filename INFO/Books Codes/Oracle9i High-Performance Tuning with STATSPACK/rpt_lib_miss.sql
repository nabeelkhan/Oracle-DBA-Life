--**************************************************************
--   rpt_lib_miss.sql
--
--   © 2001 by Donald K. Burleson
--
--   No part of this SQL script may be copied. Sold or distributed
--   without the express consent of Donald K. Burleson
--**************************************************************
set lines 80;
set pages 999;

column mydate heading 'Yr.  Mo Dy  Hr.' format a16
column c1 heading "execs"    format 9,999,999
column c2 heading "Cache Misses|While Executing"    format 9,999,999
column c3 heading "Library Cache|Miss Ratio"     format 999.99999

break on mydate skip 2;

select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   sum(new.pins-old.pins)                c1,
   sum(new.reloads-old.reloads)          c2,
   sum(new.reloads-old.reloads)/
   sum(new.pins-old.pins)                library_cache_miss_ratio
from 
   stats$librarycache old,
   stats$librarycache new,
   stats$snapshot     sn
where
   new.snap_id = sn.snap_id
and
   old.snap_id = new.snap_id-1
and
   old.namespace = new.namespace
group by
   to_char(snap_time,'yyyy-mm-dd HH24')
;

