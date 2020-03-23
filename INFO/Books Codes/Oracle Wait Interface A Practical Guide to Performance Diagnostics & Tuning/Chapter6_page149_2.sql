select location, 
       parent_name, 
       wtr_slp_count, 
       sleep_count, 
       longhold_count
from   v$latch_misses
where  sleep_count > 0 
order by wtr_slp_count, location;
