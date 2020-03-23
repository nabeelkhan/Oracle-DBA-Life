select view_name
from   dba_views
where  owner = ‘SYS’
and    view_name like ‘DBA\_HIST\_%’ escape ‘\’;



