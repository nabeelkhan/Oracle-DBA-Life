select sid, event, seconds_in_wait, state
from v$session_wait
where event = 'log buffer space%'
/
