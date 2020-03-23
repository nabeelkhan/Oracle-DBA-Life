REM rbs.sql
REM
REM This script lists schemas and the rollback segments they are using
REM

col "User" form a10
col "Table Name" form a10
col "Rollback segment name" form a21
select /*+ RULE */
       rn.usn "Rollback segment number",
       rn.name "Rollback segment name",
       sess.schemaname "User",
       o.name "Table Name"
from
       v$rollname rn,
       v$session sess,
       sys.obj$ o,
       v$lock lck1,
       v$transaction t
where
       sess.taddr = t.addr
and    lck1.sid = sess.sid
and    lck1.id1 = o.obj#
and    lck1.type = 'TM'
and    t.xidusn = rn.usn
