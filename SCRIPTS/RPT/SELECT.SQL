REM select.sql checked out on 6/9/97 17:05:16 version 1.5
set heading off
set feedback off
set verify off
set embedded on
set pagesize 0
set arraysize 2
set space 0
set wrap off
set linesize 80 
column buff fold_after 1
column max_column_id new_value max_id noprint;

select max(column_id) max_column_id
from all_tab_columns
where table_name = upper('&1')
and   owner = upper('&2');

select 
'SELECT ' buff
from dual;

select
'       '||decode(column_id,&max_id, column_name,column_name||',') buff
from all_tab_columns 
where table_name = upper('&1')
and   owner = upper('&2')
order by column_id;

select 
'FROM &1' buff,
'WHERE ' buff
from dual;
