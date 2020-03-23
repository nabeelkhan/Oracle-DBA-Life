REM gncrtrol.sql checked out on 7/10/96 17:05:14 version 1.5
set termout off
REM ---- Enter the role ( or wildcard ) to recreate:%
define usr_role= '&1'

REM ---- Enter the application or database name for the report:?
define app_name= '&2'

REM ---- Var '&3' not used

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter the  output file name for the script:$report_name.sql
define output_file = '&6'

REM ---- Var '&7' not used

REM ----- The home directory for the script files
define tool_home='/home/marcm/dba_rpt'

set pagesize 0
set linesize 132
set verify off
set feedback off

column buff fold_after 1 word_wrapped

set termout on
prompt
prompt Generating  SQL script to create roles
prompt  for roles like &usr_role
prompt
select
'There are '||count(name)||' roles' buff,
'with role names like: ''&usr_role''.' buff
from sys.user$
where name like upper('&usr_role')
  and type = 0
  and name != '_NEXT_USER';
set termout off

start &tool_home/rptvars
spool &output_file
select 'set termout on' buff,
'REM SQL script to create roles for role name like &usr_role' buff,
'REM for application: &app_name' buff
from dual;
select 
'create role '||name||decode(password,null,' not identified;','EXTERNAL',' identified externally;',' identified by values '''||password||''';') buff
from sys.user$
where name like upper('&usr_role')
  and type = 0
  and name != '_NEXT_USER'
order by 1 desc;
spool off
set feedback on
set termout on
start &tool_home/ppcmd
exit
