set pages 999;
set lines 80;

column mydate heading 'Yr.  Mo Dy Hr'     format a13;
column event                              format a30;
column waits                              format 999,999;
column secs_waited                        format 999,999,999;
column avg_wait_secs                      format 99,999;

break on to_char(snap_time,'yyyy-mm-dd') skip 1;

select 
   to_char(snap_time,'yyyy-mm-dd HH24')           mydate,
   e.event,
   e.total_waits - nvl(b.total_waits,0)           waits,
   ((e.time_waited - nvl(b.time_waited,0))/100) /
   nvl((e.total_waits - nvl(b.total_waits,0)),0)  avg_wait_secs
from 
   stats$system_event b,
   stats$system_event e,
   stats$snapshot     sn
where
   e.snap_id = sn.snap_id
and
   b.snap_id = e.snap_id-1
and
   b.event = e.event
and
  (
   e.event like 'SQL*Net%'
   or
   e.event in (
      'latch free',
      'enqueue',
      'LGWR wait for redo copy',
      'buffer busy waits'
     )
   )
and
   e.total_waits - b.total_waits  > 100
and
   e.time_waited - b.time_waited > 100
;
