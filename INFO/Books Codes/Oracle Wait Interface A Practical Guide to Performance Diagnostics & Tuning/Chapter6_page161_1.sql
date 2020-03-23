select count(distinct(hladdr)) 
from   x$bh;


select count(*) 
from   v$latch_children 
where  name = 'cache buffers chains';
