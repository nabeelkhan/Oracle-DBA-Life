select cache#, type, parameter, gets, getmisses, modifications mod 
from   v$rowcache 
where  gets > 0 
order by gets;
