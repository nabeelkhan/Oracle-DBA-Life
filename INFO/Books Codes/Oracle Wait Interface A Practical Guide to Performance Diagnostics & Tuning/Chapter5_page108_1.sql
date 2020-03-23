select b.sid,
       nvl(substr(a.object_name,1,30),
                  'P1='||b.p1||' P2='||b.p2||' P3='||b.p3) object_name,
       a.subobject_name,
       a.object_type
from   dba_objects a, v$session_wait b, x$bh c
where  c.obj   = a.object_id(+)
and    b.p1    = c.file#(+)
and    b.p2    = c.dbablk(+)
and    b.event = 'db file sequential read'
union
select b.sid,
       nvl(substr(a.object_name,1,30),
                  'P1='||b.p1||' P2='||b.p2||' P3='||b.p3) object_name,
       a.subobject_name,
       a.object_type
from   dba_objects a, v$session_wait b, x$bh c
where  c.obj   = a.data_object_id(+)
and    b.p1    = c.file#(+)
and    b.p2    = c.dbablk(+)
and    b.event = 'db file sequential read'
order by 1;
