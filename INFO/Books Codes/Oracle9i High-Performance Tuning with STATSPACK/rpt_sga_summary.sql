column chg_bytes format 999,999,999
column min_bytes format 999,999,999
column max_bytes format 999,999,999
column name      format a25

select  
   name, 
   min(bytes)             min_bytes,
   max(bytes)             max_bytes,
   max(bytes)-min(bytes)  chg_bytes
from
   stats$sgastat_summary
having
   min(bytes) < max(bytes)
group by name
;
