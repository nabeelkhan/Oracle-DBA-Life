select sql_text,
sid,
c.username,
machine,
tablespace,
extents,
blocks
from sys.v_$sort_usage a,
sys.v_$sqlarea b,
sys.v_$session c
where a.sqladdr = b.address and
a.sqlhash = b.hash_value and
a.session_addr = c.saddr
order by sid
/
select s.sid || ',' || s.serial# sid,
s.username,
u.tablespace,
substr(a.sql_text, 1, (instr(a.sql_text, ' ')-1)) sql_text,
round(((u.blocks*p.value)/1024/1024),2) size_mb
from v$sort_usage u,
v$session s,
v$sqlarea a,
v$parameter p
where s.saddr = u.session_addr
and a.address (+) = s.sql_address
and a.hash_value (+) = s.sql_hash_value
and p.name = 'db_block_size'
group by
s.sid || ',' || s.serial#,
s.username,
substr(a.sql_text, 1, (instr(a.sql_text, ' ')-1)),
u.tablespace,
round(((u.blocks*p.value)/1024/1024),2)
/
