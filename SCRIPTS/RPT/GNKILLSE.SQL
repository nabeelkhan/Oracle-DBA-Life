REM gnkillse.sql checked out on 8/15/97 17:05:14 version 1.8
set termout off
REM ---- Enter the ORACLE username (logged into ORACLE) for the sessions to be killed:%
define user_name = '&1'

REM ---- Enter the Operating System user owning the process logged into ORACLE for the session to be killed:%
define osuser = '&2'

REM ---- Enter the ORACLE SID of the process to kill:%
define orasid = '&3'

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter the  output file name for the script:$report_name.sql
define output_file = '&6'

REM ---- Var '&7' not used

REM ----- The home directory for the script files
define tool_home='/home/marcm/dba_rpt'

set pagesize 0
set verify off
set feedback off

column sid_where_txt new_value sid_where noprint
select decode('&orasid', '%', '', '0', '', 'and sid = &orasid') sid_where_txt
from dual;

start &tool_home/rptvars
spool &output_file
select 'set termout on' buff
from dual;
select 
'PROMPT Killing session owned by: '||username||'    SID: '||sid||'    Serial#: '||serial# buff,
'alter system kill session '''||sid||','||serial#||''';' buff
from v$session
where username like upper('&user_name')
  and osuser like '&osuser' &sid_where
order by username;
spool off
set feedback on
set termout on
start &tool_home/ppcmd
rem start &output_file
rem host rm  &output_file
exit
