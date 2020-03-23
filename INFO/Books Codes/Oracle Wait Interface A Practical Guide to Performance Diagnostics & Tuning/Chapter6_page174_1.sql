select * 
from   x$ktadm 
where  KSQLKADR in (select kaddr from v$lock where type = 'TM');
