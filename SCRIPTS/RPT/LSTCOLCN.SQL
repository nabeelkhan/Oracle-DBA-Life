REM lstcolcn.sql checked out on 6/12/97 17:05:15 version 1.8
set termout off
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the table name or wildcard to Match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var &4 not used

REM ---- Var &5 not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

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
center 'Table Column Referential Check Constraints (Constraint type = ''C'') with owner like &owner and Names like &prefix' skip 2

btitle center 'Report: lstcolcn'

set termout on
prompt
prompt ******** Running DBA List Column Constraints Report
prompt Generating description of all tables for owner = &owner
prompt Please wait . . .
prompt
set termout off

set feedback off
set verify off
set heading off
set arraysize 2

column table_name heading Table format a30
column comments word_wrapped heading 'Description' format a54
column search_condition word_wrapped heading Condition format a30
break on table_name skip 1 on comments
set heading on

spool &output_file

select
alc.table_name, alcom.comments,alc.search_condition 
from 
	all_tab_comments alcom,
	all_constraints alc
where alc.table_name like upper('&prefix')
  and alcom.owner like upper('&owner')
  and alc.owner = alcom.owner
  and alc.table_name = alcom.table_name
  and alc.constraint_type = 'C'
order by alc.table_name;

spool off
start &tool_home/ppcmd
exit
