select * 
from   v$system_event 
where event = 'free buffer waits';
