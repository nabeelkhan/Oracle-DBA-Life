-- Using the P1RAW from the above example (00000400837D7800).
select a.hladdr, a.file#, a.dbablk, a.tch, a.obj, b.object_name
from   x$bh a, dba_objects b
where  (a.obj = b.object_id  or  a.obj = b.data_object_id)
and    a.hladdr = '00000400837D7800'
union
select hladdr, file#, dbablk, tch, obj, null
from   x$bh
where  obj in (select obj from x$bh where hladdr = '00000400837D7800'
               minus
               select object_id from dba_objects
               minus
               select data_object_id from dba_objects)
and    hladdr = '00000400837D7800'
order by 4;
