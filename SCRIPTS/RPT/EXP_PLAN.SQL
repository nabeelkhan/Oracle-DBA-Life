REM exp_plan.sql checked out on 1/18/97 17:05:14 version 1.7
set termout off
REM ---- Enter the Statement id of the explained SQL or wildcard to match:%
define statement = '&1'

REM ---- Var '&2' not used

REM ---- Enter the Title for the top of the report:?
define app_name = '&2'

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Copied from ORACLE DBA Book
rem by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Explain SQL for statement id like &statement'

set termout on
prompt
prompt ******** Running DBA Explain SQL Report
prompt Generating explain description
prompt for statement Id like:   &statement
prompt
set termout off

column statement_id heading 'Statement Id' format a30
column query_plan heading 'Query Plan' format a96 

break on report on statement_id skip 2

set verify off
set feedback off
spool &output_file

select statement_id,lpad(' ',2*(level-1))||nvl(parent_id, 0)||'.'||id||'  '||operation||' '||options||' '||object_type||' '||object_owner||decode(object_owner,NULL,NULL,'.')||object_name||decode(id,0,decode(position, NULL, 'Rule Based','Cost = '||position))||
decode(search_columns,'','',' on columns: '||search_columns) query_plan
from plan_table where statement_id like '&statement'
start with id = 0 
connect by prior id = parent_id and prior statement_id = statement_id
order by statement_id, id
/
spool off
start &tool_home/ppcmd
exit
