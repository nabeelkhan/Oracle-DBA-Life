select /*+ ordered */
       a.sid,
       decode(a.type, 'BACKGROUND', 'BACKGROUND-' || 
substr(a.program,instr(a.program,'(',1,1)), 'FOREGROUND') type,
       b.time_waited,
       round(b.time_waited/b.total_waits,4) average_wait,
       round((sysdate - a.logon_time)*24) hours_connected
from   v$session_event b, v$session a
where  a.sid   = b.sid
and    b.event = 'control file parallel write'
order by type, time_waited;
