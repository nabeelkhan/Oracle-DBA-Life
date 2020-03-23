select indx, spin, yield, waittime
from   x$ksllclass;


select latch#, name 
from   v$latchname 
where name = 'cache buffers chains';


