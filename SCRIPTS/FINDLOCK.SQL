select username, v$lock.sid, serial#, v$lock.type TYPE, a.name ID1_NAME, lmode LK, request RQ
from   v$lock, obj$ a, obj$ b, v$session
where  id1 = a.obj#
and    id2 = b.obj# (+)
and    a.owner# <> 0
and    v$lock.sid = v$session.sid
/
