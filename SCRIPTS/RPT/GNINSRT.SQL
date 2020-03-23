REM gninsrt.sql checked out on 4/9/97 17:05:14 version 1.7
set termout off
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the table name or wildcard string:%
define prefix = '&2'

REM ---- Var &3 not used

REM ---- Var &4 not used

REM ---- Var &5 not used

REM ---- Enter the Output file name for the report:$report_name.sql
define output_file='&6'

REM ---- Var &7 not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars

define temp_file= make_insert.sql
set heading off
set feedback off
set pagesize 0
set verify off

column buff fold_after 1
column struct_name fold_after 1
column col_len new_value collen 
column col_name new_value colname

set termout on
prompt
prompt ******** Running DBA Create Default Insert SQL 
prompt Checking tables for owner: &owner with table names like:  &prefix
prompt Generating macro to create default INSERT clauses for all tables and views'
prompt
set termout off

spool &temp_file

select 'column column_len format a44' buff,
'column column_type format a26' buff,
'column column_name format a9'
from dual;

select 'prompt Creating INSERT file' buff,
'prompt Please wait . . .' buff,
'set termout off' buff,
'spool &output_file' buff
from dual;

select 'start &tool_home/insert '||table_name||' '||owner struct_name
from all_tables
where table_name like upper('&prefix')
and owner like upper('&owner')
order by table_name;

select
'spool off' buff
from dual;



spool off
set heading on
set feedback on
set termout on
prompt Running intermediate output file:  &temp_file
start &temp_file
host rm &temp_file
start &tool_home/ppcmd
exit
