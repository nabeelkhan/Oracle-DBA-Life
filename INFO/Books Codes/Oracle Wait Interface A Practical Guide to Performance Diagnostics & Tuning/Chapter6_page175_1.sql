select sid, event, p1, p1raw, 
    chr(bitand(P1,-16777216)/16777215)||chr(bitand(P1,16711680)/65535) type,
       mod(P1, 16) "MODE"
from   v$session_wait
where  event = 'enqueue';
