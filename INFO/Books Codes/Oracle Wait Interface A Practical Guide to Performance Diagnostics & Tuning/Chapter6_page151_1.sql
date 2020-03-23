select name, gets, misses, immediate_gets, immediate_misses, sleeps 
from   v$latch 
order by sleeps;
