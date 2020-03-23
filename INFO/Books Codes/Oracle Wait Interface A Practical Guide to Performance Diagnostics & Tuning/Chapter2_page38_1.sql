select sid, seq#, event, p1, p2, p3, wait_time
from   v$session_wait_history
here   sid = <sid>;


