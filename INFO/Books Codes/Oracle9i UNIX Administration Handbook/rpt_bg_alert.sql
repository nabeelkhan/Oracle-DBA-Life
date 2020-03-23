Set pages 999;


column mydate heading 'Yr.  Mo Dy Hr'     format a13;
column event                              format a30;
column total_waits    heading 'tot waits' format 999,999;
column time_waited    heading 'time wait' format 999,999;
column total_timeouts heading 'timeouts'  format 9,999;

break on to_char(snap_time,'yyyy-mm-dd') skip 1;

select 
   to_char(snap_time,'yyyy-mm-dd HH24')           mydate,
   e.event,
   e.total_waits - nvl(b.total_waits,0)           total_waits,
   e.time_waited - nvl(b.time_waited,0)           time_waited,
   e.total_timeouts - nvl(b.total_timeouts,0)     total_timeouts
from 
   stats$bg_event_summary     b,
   stats$bg_event_summary     e,
   stats$snapshot     sn
where
   e.event not like '%timer' 
and 
   e.event not like '%message%'
and
   e.snap_id = sn.snap_id
and
   b.snap_id = e.snap_id-1
and
   b.event = e.event
and
   e.total_timeouts > 100
and
(
   e.total_waits - b.total_waits  > 100
   or
   e.time_waited - b.time_waited > 100
)
;
