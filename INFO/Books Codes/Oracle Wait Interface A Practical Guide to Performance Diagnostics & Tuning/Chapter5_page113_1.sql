select a.sid, b.name, a.value
from   v$sesstat a, v$statname b
where  a.statistic# = b.statistic#
and    a.value     <> 0
and    b.name = 'table scan blocks gotten'
order by 3,1;
