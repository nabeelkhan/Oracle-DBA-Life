select * 
from   v$sysstat
where  name in ('write clones created in foreground',
                'write clones created in background');
