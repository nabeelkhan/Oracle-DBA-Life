REM insert.sql checked out on 4/9/97 17:05:15 version 1.4
set heading off
set feedback off
set verify off
set embedded on
set pagesize 0
set space 0
set wrap off
set linesize 50 
column buff fold_after 1
column max_column_id new_value max_id noprint;

select max(column_id) max_column_id
from all_tab_columns
where table_name = upper('&1')
and   owner = upper('&2');

select 
'INSERT INTO '||'&1'||' (' buff
from dual;

select
'       '||decode(column_id,&max_id,column_name||' )',column_name||',') buff
from all_tab_columns 
where table_name = upper('&1')
and   owner = upper('&2')
order by column_id;

select 
'VALUES (' buff
from dual;

select
'       '||decode(column_id,&max_id,lower(decode(substr(column_name,length(column_name)-6),'EDIT_DT','sysdate','USER_ID','user',':'||column_name))||')',
			      lower(decode(substr(column_name,length(column_name)-6),'EDIT_DT','sysdate','USER_ID','user',':'||column_name))||',') buff
from all_tab_columns 
where table_name = upper('&1')
and   owner = upper('&2')
order by column_id;
