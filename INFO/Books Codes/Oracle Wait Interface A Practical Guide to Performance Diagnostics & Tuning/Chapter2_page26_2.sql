break on sid skip 1 dup
col sid      format 999
col event    format a39
col username format a6   trunc
select b.sid, 
       decode(b.username,null,
              substr(b.program,18),b.username) username,
       a.event,
       a.total_waits,
       a.total_timeouts,
       a.time_waited,
       a.average_wait,
       a.max_wait,
       a.time_waited_micro
from   v$session_event a, v$session b
where  b.sid = a.sid + 1
order by 1, 6;

