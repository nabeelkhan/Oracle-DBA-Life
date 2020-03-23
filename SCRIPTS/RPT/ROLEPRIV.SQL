REM rolepriv.sql checked out on 6/12/97 17:05:16 version 1.7
set termout off
REM ---- Enter the Grantee to look for or wildcard:%
define grantee='&1'

REM ---- Enter the role name or wildcard to match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var &4 not used

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
center 'List of roles granted to grantees like &grantee  with role names like &prefix' skip 2

btitle center 'Report: rolepriv'

column grantee heading 'Grantee' format a30
column granted_role heading 'Granted Role' format a30
column admin_option heading 'Admin Granted|(Y/N)' format a30
column default_role heading 'Default|(Y/N)' format a15

break on report on table_name on column_name skip 2 on privilege skip 1

set feedback off
set verify off
set heading off

set termout on
prompt
prompt ******** Running DBA Role Report
prompt
set termout off

set headin on
set feedback off
break on report on granted_role skip 1

spool &output_file
select
  grantee,
  granted_role,
  admin_option,
  default_role
from dba_role_privs
where grantee like upper('&grantee')
  and granted_role like upper('&prefix')
order by 2,1
/
spool off
start &tool_home/ppcmd
exit
