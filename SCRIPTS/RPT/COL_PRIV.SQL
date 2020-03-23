REM col_priv.sql checked out on 10/18/97 17:05:12 version 1.8
set termout off
REM ---- Enter the Owner or wildcard of the tables to match:%
define owner = '&1'

REM ---- Enter the table_name or wildcard to match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter Grantee or wildcard who received the grants:%
define grantee = '&4'

REM ---- Enter the Privilege granted to search for or wildcard:%
define priv = '&5'

REM ---- Enter the Output file for the report:$report_name.lst
define output_file = '&6'

REM ---- Var &7 not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1990 
rem Copyright 1996, 1997
rem The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Column Grants for objects owned by &owner with names like &prefix'

btitle center 'Report: col_priv'

column table_name heading 'Table Name' format a27
column column_name heading 'Column Name' format a27
column privilege heading 'Privilege' format a10
column grantee heading 'Grantee' format a27
column grantor heading 'Grantor' format a27
column grantable heading 'Admin' format a3

break on report on table_name on column_name skip 2 on privilege skip 1

set feedback off
set verify off
set heading off

set termout on
prompt
prompt ******** Running DBA Column Grants Report
prompt
set termout off

set headin on
set feedback off

spool &output_file
select
  table_name,
  column_name,
  privilege,
  grantee,
  grantor,
  grantable
from all_col_privs
where table_schema like upper('&owner')
  and table_name like upper('&prefix')
  and grantee like upper('&grantee')
  and privilege like upper('&priv')
order by 1,2,3,4
/
spool off
start &tool_home/ppcmd
exit
