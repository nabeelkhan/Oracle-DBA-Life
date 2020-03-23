select event, time_waited, average_wait 
from   v$system_event 
where  event in ('db file parallel write','free buffer waits', 
'write complete waits'); 
