select owner, 
       object_name 
from   v$segment_statistics
where  statistic_name ='itl waits' and value > 0;



















