select a.ksppinm, b.ksppstvl 
from   x$ksppi a, x$ksppsv b 
where  a.indx = b.indx 
and    a.ksppinm = '_kghdsidx_count';


select addr, kghluidx, kghlufsh, kghluops, kghlurcr, kghlutrn, kghlumxa 
from   x$kghlu;


select addr, name, gets, misses, waiters_woken
from   v$latch_children 
where name = 'shared pool';
