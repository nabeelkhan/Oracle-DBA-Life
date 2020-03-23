select name 
from   v$event_name 
where  name like 'latch%' 
order by 1;
