select * 
from   v$resource_limit 
where  resource_name in ('enqueue_resources','enqueue_locks',
'dml_locks','processes','sessions');
