select owner,
       substr(object_name,1,30) object_name,
       object_type,
       created
from   dba_objects
where  object_type in ('INDEX','INDEX PARTITION')
order by created;
