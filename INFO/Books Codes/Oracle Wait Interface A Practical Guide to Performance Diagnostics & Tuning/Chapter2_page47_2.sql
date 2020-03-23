select  a.value A, b.value B, c.value C, d.value D
from    (select sum(bbwait) AS value 
         from   x$kcbwds) a,
        (select total_waits AS value 
         from   v$system_event 
         where  event = 'buffer busy waits') b,
        (select sum(count) AS value 
         from   v$waitstat) c,
        (select sum(value) AS value 
         from   v$segment_statistics 
         where  statistic_name = 'buffer busy waits') d;




