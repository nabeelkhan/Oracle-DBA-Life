select session_id, event, count(*), sum(time_waited)
from   v$active_session_history
where  session_state = 'WAITING'
and    time_waited > 0
and    sample_time >= (sysdate - &HowLongAgo/(24*60))
group by session_id, event;









