REM roles.sql checked out on 6/12/97 17:05:16 version 1.6
set termout off
REM ---- Var &1 not used

REM ---- Enter the role name or wildcard string to match:%
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
center 'List of roles defined with role names like &prefix' skip 2

btitle center 'Report: roles'

column role heading 'Role' format a30
column password_required heading 'Password|Required' format a10

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

spool &output_file
select
  role,
  password_required
from dba_roles
where role like upper('&prefix')
order by 1,2
/
spool off
start &tool_home/ppcmd
exit
