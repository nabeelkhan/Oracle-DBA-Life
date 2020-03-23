set pages 999;
set lines 80;

column mydate heading 'Yr.  Mo Dy Hr'     format a13;
column name                              format a20;
column gets                         format 999,999;
column waits                               format 999,999,999;
column avg_wait_secs                      format 99,999;

break on to_char(snap_time,'yyyy-mm-dd') skip 1;

select 
   to_char(snap_time,'yyyy-mm-dd HH24')           mydate,
   e.name,
   e.gets - nvl(b.gets,0)             gets,
   e.waits - nvl(b.waits,0)                         waits
from 
   stats$enqueuestat     b,
   stats$enqueuestat     e,
   stats$snapshot        sn
where
   e.snap_id = sn.snap_id
and
   b.snap_id = e.snap_id-1
and
   b.name = e.name
and
   e.gets - b.gets  > 1
and
   e.waits - b.waits > 1
;
