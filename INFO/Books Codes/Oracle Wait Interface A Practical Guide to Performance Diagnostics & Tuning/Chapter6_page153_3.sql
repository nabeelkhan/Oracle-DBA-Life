select a.sid, c.username, b.name, a.value, 
       round((sysdate - c.logon_time)*24) hours_connected
from   v$sesstat a, v$statname b, v$session c
where  c.sid        = a.sid
and    a.statistic# = b.statistic#
and    a.value      > 0
and    b.name       = 'parse count (hard)'
order by a.value;
