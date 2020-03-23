select table_name 
from   dba_tables
where  owner = ‘SYS’
and    table_name like ‘WR%’;


