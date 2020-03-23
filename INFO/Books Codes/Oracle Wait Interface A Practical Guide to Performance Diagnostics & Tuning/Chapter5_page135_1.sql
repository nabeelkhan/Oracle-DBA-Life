select event, time_waited, average_wait
from   v$system_event
where  event in ('log file parallel write','log file sync');
