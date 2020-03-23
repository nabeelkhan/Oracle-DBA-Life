select version_count, sql_text 
from   v$sqlarea 
where  version_count > 20 
order by version_count, hash_value;
