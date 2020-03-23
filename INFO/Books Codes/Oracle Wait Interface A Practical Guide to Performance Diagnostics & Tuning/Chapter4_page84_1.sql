create table system.session_event_history 
tablespace <name>
storage (freelist groups <value>)
initrans <value>
as 
select b.sid,
       b.serial#,
       b.username,
       b.osuser,
       b.paddr,
       b.process,
       b.logon_time,
       b.type,
       a.event,
       a.total_waits,  
       a.total_timeouts, 
       a.time_waited, 
       a.average_wait, 
       a.max_wait, 
       sysdate as logoff_timestamp
from   v$session_event a, v$session b
where  1 = 2;

