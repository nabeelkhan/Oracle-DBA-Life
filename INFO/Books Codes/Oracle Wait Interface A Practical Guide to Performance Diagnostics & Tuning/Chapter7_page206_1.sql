select * 
from   v$sysstat 
where  name in ('free buffer requested', 'free buffer inspected');
