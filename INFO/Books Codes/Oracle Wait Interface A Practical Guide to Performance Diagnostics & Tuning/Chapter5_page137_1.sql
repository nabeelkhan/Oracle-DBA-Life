select b.name, a.value, round(sysdate - c.startup_time) days_old
from   v$sysstat a, v$statname b, v$instance c
where  a.statistic# = b.statistic# 
and    b.name      in ('redo wastage','redo size');
