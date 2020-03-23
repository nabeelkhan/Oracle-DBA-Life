REM lstindx.sql checked out on 8/15/97 17:05:15 version 1.8
set termout off
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the table name or wildcard to Match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter the INDEX owner or wildcard to match:%
define index_owner = '&4'

REM ---- Var '&5' not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Defined Indexes with Owner Names like ''&owner'' and Index Names like ''&prefix'' and index owner like ''&index_owner'''  skip 2

btitle center 'Report: lstindx'

set termout on
prompt
prompt ******** Running DBA List Index Report
prompt for owner like:       &owner
prompt and table name like:  &prefix
prompt and index owner like: &index_owner
prompt
set termout off

set feedback off
set verify off

column tablename heading Table format a30
column indexname heading 'Index Name' format a30
column column_name heading 'Column|(In order of Index)'
break on tablename on indexname skip 2

spool &output_file
select ac.table_name tablename,
decode(uniqueness,'UNIQUE','UNIQUE ','')||ac.index_name indexname,column_name
from all_ind_columns ac,all_indexes ai
where ac.table_owner like upper('&owner')
and   ac.table_owner = ai.table_owner
and   ac.table_name like upper('&prefix')
and   ai.owner like upper('&index_owner')
and   ac.table_name = ai.table_name
and   ac.index_name = ai.index_name
order by ac.table_name,ac.index_name,column_position;
spool off
start &tool_home/ppcmd
exit
