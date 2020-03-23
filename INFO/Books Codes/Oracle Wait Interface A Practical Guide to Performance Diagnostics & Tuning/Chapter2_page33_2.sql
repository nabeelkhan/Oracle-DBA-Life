select s.username, 
       p.spid os_process_id, 
       p.pid oracle_process_id
from   v$session s, v$process p
where  s.paddr = p.addr
and    s.username = upper(‘&user_name’);

-- Now, use SQL*Plus to connect as sysdba, and then issue following commands:

alter system set timed_statistics = true;
oradebug setospid 12345;  
-- 12345 is the OS process id for the session
oradebug unlimit;
oradebug event 10046 trace name context forever, level 8;
-- Let the session execute SQL script 
-- or program for some amount of time 

-- To turn off the tracing:
oradebug event 10046 trace name context off;





