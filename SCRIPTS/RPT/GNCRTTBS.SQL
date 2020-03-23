REM gncrttbs.sql checked out on 10/18/97 17:05:15 version 1.6
set termout off
REM ---- Enter the tablespace name or wildcard to match:%
define prefix = '&1'

REM ---- Var '&2' not used

REM ---- Var '&3' not used

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter the output file name for the script:$report_name.sql
define output_file = '&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

REM ----- Temporary file for generation
define temp_file = mkcrttbs.sql

rem
rem Created by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars

set heading off
set feedback off
set pagesize 0
set verify off

column buff fold_after 1

set termout on
prompt Generating  SQL script to create tablespaces
prompt  with names like &prefix
prompt
select
'There are '||count(dbt.tablespace_name)||' tablespaces' buff,
'with names like: ''&prefix''.' buff
from dba_tablespaces dbt
where dbt.tablespace_name like upper('&prefix');
set termout off

spool &temp_file

select 'prompt Creating SQL Script file &output_file' buff,
'prompt' buff,
'column buff fold_after 1' buff,
'set feedback off' buff,
'set termout off' buff,
'spool &output_file' buff
from dual;

select 'start &tool_home/crt_tbsp '||tablespace_name
from dba_tablespaces
where tablespace_name like upper('&prefix')
order by tablespace_name;
REM  and status != 'INVALID'

select
'spool off' buff,
'prompt' buff,
'set termout on' buff,
'start &tool_home/ppcmd' buff
from dual;



spool off
set heading on
set feedback on
set termout on
prompt Running intermediate output file:  &temp_file
start &temp_file
host rm &temp_file
exit
