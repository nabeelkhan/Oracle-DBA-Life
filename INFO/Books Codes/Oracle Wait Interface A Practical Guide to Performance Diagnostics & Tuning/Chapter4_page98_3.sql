select a.sid,  a.serial#,  a.username,  a.paddr,  a.logon_time,
       a.sql_hash_value,   b.type,      b.lmode,  b.ctime
from   v$session a, v$lock b
where  a.sid   = b.sid
and    b.id1   = <cursor P2>
and    b.id2   = <cursor P3>
and    b.block = 1;





