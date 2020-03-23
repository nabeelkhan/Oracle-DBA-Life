col Name format a4
select sid,
       chr(bitand(p1, -16777216)/16777215) ||
       chr(bitand(p1,16711680)/65535) "Name",
       (bitand(p1, 65535)) "Mode"
from   v$session_wait
where  event = 'enqueue';






