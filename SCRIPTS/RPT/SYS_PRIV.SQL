REM sys_priv.sql checked out on 10/18/97 17:05:16 version 1.7
set termout off
REM ---- Var &1 not used

REM ---- Enter the grantee or wildcard to match:%
define grantee = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter the Privilege to search for or wildcard:%
define priv = '&4'

REM ---- Var &5 not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file = '&6'

REM ---- Var &7 not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'List of system privileges granted to users or to roles with names like &grantee' skip 2

btitle center 'Report: sys_priv'

column grantee heading 'Grantee' format a30
column prifilege heading 'System Privilege' format a30
column admin_option heading 'Admin Granted|(Y/N)' format a30

set feedback off
set verify off
set heading off

set termout on
prompt
prompt ******** Running DBA System Privilege Report
prompt
set termout off

set headin on
set feedback off
break on report on grantee skip 1

spool &output_file
select
  grantee,
  privilege,
  admin_option
from dba_sys_privs
where grantee like upper('&grantee')
and privilege like upper('&priv')
order by 1,2
/
spool off
start &tool_home/ppcmd
exit
