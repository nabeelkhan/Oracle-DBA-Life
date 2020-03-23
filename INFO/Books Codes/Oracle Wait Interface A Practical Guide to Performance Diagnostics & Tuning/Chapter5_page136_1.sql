select sid, value 
from   v$sesstat 
where  statistic# = (select statistic# 
                     from   v$statname 
                     where  name = 'user commits')
order by value;
