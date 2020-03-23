REM fcol1.sql checked out on 10/24/96 17:05:14 version 1.4
set verify off
break on table_name skip 1
column table_name heading 'Occurs in Table' format a30
column column_name heading 'Column Name' format a30

select owner||'.'||table_name table_name, column_name
from all_tab_columns
where column_name like upper('%&1%')
order by 1;
exit
