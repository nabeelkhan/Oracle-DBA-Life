--**************************************************************
--   rpt_waitstat.sql
--
--   © 2001 by Donald K. Burleson
--
--   No part of this SQL script may be copied. Sold or distributed
--   without the express consent of Donald K. Burleson
--**************************************************************
set pages 999;
set lines 80;

column mydate heading 'Yr.  Mo Dy Hr'     format a13;
column class                              format a20;
column wait_count                         format 999,999;
column time                               format 999,999,999;
column avg_wait_secs                      format 99,999;

break on to_char(snap_time,'yyyy-mm-dd') skip 1;

select 
   to_char(snap_time,'yyyy-mm-dd HH24')           mydate,
   e.class,
   e.wait_count - nvl(b.wait_count,0)             wait_count,
   e.time - nvl(b.time,0)                         time
from 
   stats$waitstat     b,
   stats$waitstat     e,
   stats$snapshot     sn
where
   e.snap_id = sn.snap_id
and
   b.snap_id = e.snap_id-1
and
   b.class = e.class
and
(
   e.wait_count - b.wait_count  > 1
   or
   e.time - b.time > 1
)
;
