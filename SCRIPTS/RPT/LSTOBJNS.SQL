REM lstobjns.sql checked out on 8/24/97 17:05:18 version 1.4
set termout off
REM ---- Enter the owner of the table or wildcard to match:%
define owner = '&1'
 
REM ---- Enter the Table name or wildcard to match:%
define prefix = '&2'
 
REM ---- Enter Title for the top of the report:?
define app_name = '&3'
 
REM ---- Var &4 not used
 
REM ---- Var '&5' not used
 
REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'
 
REM ---- Var &7 not used
 
REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1996 For his personal use
rem Copyright 1996 The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Objects without Statistics for Object names like &prefix and Owner names like &owner' skip 2

btitle center 'Report: lstobjns'

set termout on
prompt
prompt ******** DBA List Objects Without Statistics
prompt      for &app_name 
prompt      for owner like:      &owner
prompt      and Table name like: &prefix
prompt
set termout off

set feedback off
set verify off
set heading on


column owner heading 'Owner' format a20
column table_name heading 'Table Name' format a30
column index_name heading 'Index' format a30

break on report on owner skip 2 on table_name skip 1



spool &output_file
select owner, table_name, '' index_name
from all_tables
where owner like upper('&owner')
  and table_name like upper('&prefix')
  and num_rows is null
union
select owner, table_name, index_name
from all_indexes
where owner like upper('&owner')
  and table_name like upper('&prefix')
  and blevel is null
order by 1,2,3
/
spool off
start &tool_home/ppcmd
exit
