REM lsttbcol.sql checked out on 12/22/97 17:05:16 version 1.9 created on 12/14/97 09:53:25
set termout off
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the table name or wildcard to Match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter switch to look at tables only (Y) or include views (N):Y
define tables_only='&4'

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
column where_txt new_value where_clause noprint
select decode(upper('&tables_only'), 'Y', '(''TABLE'')', '(''TABLE'',''VIEW'')') where_txt
from dual;

start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Tables and Column definitions for Owner like &owner and Table Names like &prefix Tables Only (&tables_only)' skip 2

btitle center 'Report: lsttbcol'

set feedback off
set verify off
set heading on

set termout on
prompt
prompt ******** Running DBA List Columns and Comments Report
prompt Generating description of tables/views columns 
prompt for owner like:      &owner
prompt and table name like: &prefix
prompt and tables only:     &tables_only
prompt 
set termout off

column tablename heading Table format a30
column column_name heading Column format a30
column length heading Type format a14
column nulls heading Null? format a9
column comments WORD_WRAPPED heading Definition format a37
break on tablename skip 2

spool &output_file
select /*+ RULE */
ac.table_name tablename,ac.column_name,decode(nullable,'Y','','N','NOT NULL') nulls,
data_type||decode(data_type,'NUMBER',decode(nvl(data_precision,-1),'-1',decode(nvl(data_scale,-1),'-1','','(38'),'('||
data_precision), 'DATE','','LONG','','LONG RAW','','MLSLABEL','','ROWID','','('||data_length)||
decode(data_type,'NUMBER', decode(nvl(data_scale,-1), '-1','', ','||data_scale||')') ,'DATE','', 
'LONG','', 'LONG RAW','', 'MLSLABEL','','ROWID','',')') length,
comments
from 
	all_col_comments alcom,
	all_tab_columns ac,
	all_objects ao
where ac.owner like upper('&owner')
And   ac.table_name like upper('&prefix')
and   ac.owner = alcom.owner
and   ao.owner = ac.owner
and   ao.object_name = ac.table_name
and   ac.table_name = alcom.table_name
and   ac.column_name = alcom.column_name
and   ao.object_type in &where_clause
order by ac.table_name,column_id;
spool off
start &tool_home/ppcmd
exit
