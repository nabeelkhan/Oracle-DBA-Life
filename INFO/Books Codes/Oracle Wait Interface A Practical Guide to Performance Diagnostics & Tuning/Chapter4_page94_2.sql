select distinct a.object_name, a.subobject_name
from   dba_objects a, sys.x$bh b
where  (a.object_id = b.obj or a.data_object_id = b.obj)
 and    b.file#  = <cursor P1>
and    b.dbablk = <cursor P2>;


