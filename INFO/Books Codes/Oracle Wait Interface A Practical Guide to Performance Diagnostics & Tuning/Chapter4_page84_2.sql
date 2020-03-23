create table system.sesstat_history 
tablespace <name>
storage (freelist groups <value>)
initrans <value>
as
select c.username, 
       c.osuser,
       a.sid,
       c.serial#,
       c.paddr,
       c.process,
       c.logon_time,
       a.statistic#,
       b.name,
       a.value,
       sysdate as logoff_timestamp
from   v$sesstat a, v$statname b, v$session c
where  1 = 2;

