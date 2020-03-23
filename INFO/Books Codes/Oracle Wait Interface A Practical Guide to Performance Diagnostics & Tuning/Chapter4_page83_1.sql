-- This script creates a database logoff trigger for the purpose of 
-- collecting historical performance data during logoffs. 
-- It is applicable to Oracle8i Database and above. 
-- You must be connected as “/ as sysdba” to create this trigger.

create or replace trigger sys.logoff_trig
before logoff on database
declare
  logoff_sid    pls_integer;
  logoff_time   date         := sysdate;
begin
  select sid 
  into   logoff_sid 
  from   v$mystat
  where  rownum < 2;

  insert into system.session_event_history
        (sid, serial#, username, osuser, paddr, process,
         logon_time, type, event, total_waits, total_timeouts, 
         time_waited, average_wait, max_wait, logoff_timestamp)
  select a.sid, b.serial#, b.username, b.osuser, b.paddr, b.process,
         b.logon_time, b.type, a.event, a.total_waits, a.total_timeouts,
         a.time_waited, a.average_wait, a.max_wait, logoff_time
  from   v$session_event a, v$session b
  where  a.sid      = b.sid
  and    b.username = login_user
  and    b.sid      = logoff_sid;
-- If you are on earlier releases of Oracle9i Database, you should check to
-- see if your database is affected by bug #2429929, which causes 
-- misalignment of SID numbers between the V$SESSION_EVENT and V$SESSION
-- views. The SID number in the V$SESSION_EVENT view is off by 1. 
-- If your database is affected, please replace the above 
-- “where a.sid = b.sid” with “where b.sid = a.sid + 1”.

  insert into system.sesstat_history
        (username, osuser, sid, serial#, paddr, process, logon_time,
         statistic#, name, value, logoff_timestamp)
  select c.username, c.osuser, a.sid, c.serial#, c.paddr, c.process,
         c.logon_time, a.statistic#, b.name, a.value, logoff_time
  from   v$sesstat a, v$statname b, v$session c
  where  a.statistic#  = b.statistic#
  and    a.sid         = c.sid
  and    b.name       in ('CPU used when call started',
                          'CPU used by this session',
                          'recursive cpu usage',
                          'parse time cpu')
  and    c.sid         = logoff_sid
  and    c.username    = login_user;
end;
/
