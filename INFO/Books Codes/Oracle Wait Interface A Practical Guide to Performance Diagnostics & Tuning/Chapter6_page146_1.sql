select name, immediate_gets, immediate_misses, 
       gets, misses, sleeps, waiters_woken 
from   v$latch 
where waiters_woken > 0;
