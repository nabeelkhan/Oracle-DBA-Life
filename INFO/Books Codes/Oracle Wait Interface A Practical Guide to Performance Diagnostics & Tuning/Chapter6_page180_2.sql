select owner, 
       object_name, 
       subobject_name, 
       object_type, 
       tablespace_name, 
       value, 
       statistic_name
from   v$segment_statistics 
where  statistic_name = 'ITL waits'
and    value > 0
order by value;
