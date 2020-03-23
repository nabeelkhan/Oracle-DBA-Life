REM tab_priv.sql checked out on 10/18/97 17:05:17 version 1.8
set termout off
REM ---- Enter the Owner of the tables/objects or wildcard to match:%
define owner = '&1'

REM ---- Enter the table/object name or wildcard to match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter the Grantee or wildcard who received the grants:%
define grantee = '&4'

REM ---- Enter the Privilege to search for or wildcard:%
define priv = '&5'

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
center 'Grants for objects owned by &owner with names like &prefix to users with Names like &grantee' skip 2

btitle center 'Report: tab_priv'

column table_name heading 'Table Name' format a30
column privilege heading 'Privilege' format a10
column grantee heading 'Grantee' format a30
column grantor heading 'Grantor' format a30
column grantable heading 'Admin' format a3

break on report on table_name skip 2 on privilege skip 1

set feedback off
set verify off
set heading off

set termout on
prompt
prompt ******** Running DBA Table Grants Report
prompt
set termout off

set headin on
set feedback off

spool &output_file
select
  table_name,
  privilege,
  grantee,
  grantor,
  grantable
from all_tab_privs
where table_schema like upper('&owner')
  and table_name like upper('&prefix')
  and grantee like upper('&grantee')
  and privilege like upper('&priv')
order by 1,2,3
/
spool off
start &tool_home/ppcmd
exit
