column object_name format a35
set pagesize 50

select count(object_name)count, object_type, status
from dba_objects
where owner='TABS'
--and status <>'VALID'
--and object_type in ('TABLE','VIEW','PROCEDURE','TRIGGER','FUNCTION','PACKAGE BODY','SYNONYM')
--and object_name like '%REM%'
group by
Object_type,
--object_name,
status
order by 1,2
/