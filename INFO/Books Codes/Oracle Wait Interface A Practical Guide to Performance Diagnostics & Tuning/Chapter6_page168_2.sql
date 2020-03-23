select addr 
from   v$latch_children 
where name = 'cache buffers lru chain' 
order by addr;
