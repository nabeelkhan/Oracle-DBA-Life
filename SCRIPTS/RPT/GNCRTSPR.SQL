REM gncrtspr.sql checked out on 7/10/96 17:05:14 version 1.5
set pagesize 0
set verify off
set feedback off
set termout off
REM ---- Enter the grantee or role to have the system privileges:%
define grantee= '&1'

REM ---- Enter the privilege or wildcard to be matched:%
define priv= '&2'

REM ---- Enter the application or database name for the report:?
define app_name= '&3'

REM ---- Var '&4' not used 

REM ---- Var '&5' not used

REM ---- Enter the  output file name for the script:$report_name.sql
define output_file = '&6'

REM ---- Var '&7' not used

REM ----- The home directory for the script files
define tool_home='/home/marcm/dba_rpt'

set termout on
prompt
prompt Generating  SQL script to create system grants
prompt  for grantee like &grantee and with names like &priv
prompt
select
'There are '||count(grantee)||' grantees' buff,
'with names like: ''&grantee''.' buff
from dba_sys_privs
where grantee like upper('&grantee')
  and privilege like upper('&priv');
set termout off

start &tool_home/rptvars
spool &output_file
select 'set termout on' buff
from dual;
select 
'grant '||PRIVILEGE||' to '||GRANTEE||decode(ADMIN_OPTION,'YES',' with admin option;',';') buff
from dba_sys_privs
where grantee like upper('&grantee')
  and privilege like upper('&priv')
order by grantee, privilege;
spool off
set feedback on
set termout on
start &tool_home/ppcmd
exit
