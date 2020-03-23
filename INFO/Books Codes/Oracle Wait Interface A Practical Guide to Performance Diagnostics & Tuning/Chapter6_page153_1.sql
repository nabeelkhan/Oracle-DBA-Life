select count(*)
from   v$latch_children 
where  name = 'library cache';
