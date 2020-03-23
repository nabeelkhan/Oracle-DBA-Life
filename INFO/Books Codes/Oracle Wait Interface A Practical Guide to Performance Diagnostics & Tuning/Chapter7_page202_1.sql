select * 
from   v$system_event 
where  event in ('log file sync','log file parallel write'); 
