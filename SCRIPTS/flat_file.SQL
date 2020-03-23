accept tablename prompt 'Table to Export:'
set pause off
set heading off
set concat ~
set feedback off
set verify off
set linesize 1000
set trimspool on
set trimout on
set pages 0
set termout off
column ord noprint
spool /tmp/&&tablename.sql
select 0 ord, 'select',null,null,'rtrim('| |column_name | |')'
from user_tab_columns 
where table_name = upper('&&TableName') 
and column_id=1
union
select column_id ord, '| |' , ''';''' , '| |' ,'rtrim('| |column_name | |')'
from user_tab_columns 
where table_name = upper('&TableName') 
and column_id > 1
union
select 1000 ord, '| |' , ''';''' , null, 'from &TableName order by 1;'
from dual
order by ord;
spool off
spool /tmp/&&tablename.dat
@/tmp/&&tablename.sql
spool off
exit
/
