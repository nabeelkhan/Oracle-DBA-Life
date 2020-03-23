REM gncrtusr.sql checked out on 7/10/96 17:05:15 version 1.5
set termout off
REM ---- Enter the user ( or wildcard ) to recreate:%
define usr= '&1'

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
column rank noprint

set termout on
prompt
prompt Generating  SQL script to create users
prompt  for users like &usr
prompt
select
'There are '||count(username)||' users' buff,
'with user names like: ''&usr''.' buff
from dba_users
where username like upper('&usr');
set termout off

start &tool_home/rptvars
spool &output_file
select 'set termout on' buff,
'REM SQL script to create users for username like &usr' buff,
'REM for application: &app_name' buff
from dual;
select 
'1' rank,decode(username,'SYS','alter user '||USERNAME||' identified '||decode(password,'EXTERNAL','EXTERNALLY','by values '''||password||'''')||' temporary tablespace "'||temporary_tablespace||'" default tablespace "'||default_tablespace||'";'
	       ,'SYSTEM','alter user '||USERNAME||' identified '||decode(password,'EXTERNAL','EXTERNALLY','by values '''||password||'''')||' temporary tablespace "'||temporary_tablespace||'" default tablespace "'||default_tablespace||'";',
'create user '||USERNAME||' identified '||decode(password,'EXTERNAL','EXTERNALLY','by values '''||password||'''')||' temporary tablespace "'||temporary_tablespace||'" default tablespace "'||default_tablespace||'";') buff, ''
from dba_users
where username like upper('&usr')
union
select
'2' rank,'grant '||granted_role||' to '||grantee||decode(admin_option,'YES',' with admin option')||';' buff,
'alter user '||grantee||' default role '||granted_role||';' buff
from dba_role_privs
where grantee like upper('&usr')
  and grantee not in ('SYS','SYSTEM')
  and default_role = 'YES'
order by 1;
spool off
set feedback on
set termout on
start &tool_home/ppcmd
exit
