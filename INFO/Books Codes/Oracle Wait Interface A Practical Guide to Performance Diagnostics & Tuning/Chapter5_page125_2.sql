select decode(a.qcserial#, null, 'PARENT', 'CHILD') stmt_level,
       a.sid,
       a.serial#,
       b.username,
       b.osuser,
       b.sql_hash_value,
       b.sql_address,
       a.degree,
       a.req_degree
from   v$px_session a, v$session b
where  a.sid = b.sid
order by a.qcsid, stmt_level desc;
