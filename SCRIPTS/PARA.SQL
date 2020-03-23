select substr(name,1,30) name, substr(value,1,30) value
from   v$parameter
where name in ('db_block_buffers','db_block_size','shared_pool_size','sort_area_size')
/
