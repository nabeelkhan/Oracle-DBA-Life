Description: 

This script reports how many hours it has been since the rollback segments wrapped

Code :

select n.name, 
round(24*(sysdate-to_date(i1.value||' '||i2.value,'j SSSSS')) / 
(s.writes/s.rssize),1) "Hours" 
from v$instance i1,
v$instance i2,
v$rollname n,
v$rollstat s 
where 
i1.key = 'STARTUP TIME - JULIAN' 
and i2.key = 'STARTUP TIME - SECONDS' 
and n.usn = s.usn 
and s.status = 'ONLINE' 

