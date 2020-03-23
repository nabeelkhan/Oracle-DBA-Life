select * 
from   x$ktcxb
where  KTCXBLKP in (select kaddr from v$lock where type = 'TX');

