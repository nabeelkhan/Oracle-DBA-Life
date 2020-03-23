select * 
from   v$segment_statistics 
where  statistic_name = 'buffer busy waits' 
order by value;
