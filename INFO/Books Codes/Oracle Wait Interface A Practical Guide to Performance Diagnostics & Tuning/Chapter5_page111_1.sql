select a.event,
       a.total_waits,
       a.time_waited,
       a.time_waited/a.total_waits average_wait,
       sysdate - b.startup_time days_old
from   v$system_event a, v$instance b
order by a.time_waited;
