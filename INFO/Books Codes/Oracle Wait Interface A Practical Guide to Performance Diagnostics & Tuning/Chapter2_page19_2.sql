select wait_class#, wait_class_id, wait_class
from   v$event_name
group by wait_class#, wait_class_id, wait_class;

