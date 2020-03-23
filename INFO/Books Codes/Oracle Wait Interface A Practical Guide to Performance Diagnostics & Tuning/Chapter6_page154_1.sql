select * 
from   v$sess_time_model 
where  sid = (select max(sid) from v$mystat);
