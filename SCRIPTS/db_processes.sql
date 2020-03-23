col c1 heading 'Program|Name'         format a30
col c2 heading 'PGA|Used|Memory'      format 999,999,999
col c3 heading 'PGA|Allocated|Memory' format 999,999,999
col c4 heading 'PGA|Maximum|Memory'   format 999,999,999

select
program c1,pga_used_mem c2,pga_alloc_mem c3,pga_max_mem c4
from
v$process
order by
c4 desc;
