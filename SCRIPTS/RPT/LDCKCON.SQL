REM  ldckcon.sql checked out on 4/6/96 17:05:17 version 1.3
set termout off
set heading off
set pagesize 0
set echo off
set linesize 135

define tmp_data='^1'
set termout on
prompt Spooling to ^tmp_data
set termout off

column search_condition format a42

spool ^tmp_data
select owner,table_name,constraint_name,search_condition
from dba_constraints 
where constraint_type = 'C'
  and owner like upper('^owner')
  and table_name like upper('^prefix');
spool off
set termout on

