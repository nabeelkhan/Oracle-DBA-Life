select hladdr, count(*) 
from   x$bh 
group by hladdr 
order by 2;
