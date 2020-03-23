REM gnanalyz.sql checked out on 7/10/96 17:05:14 version 1.5
set termout off
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the table name or wildcard to match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter the Switch to togle compute or estimate (c,C or e,E):C
define compute_opt='&4'

REM ---- Var '&5' not used

REM ---- Enter the Output file name for the report:$report_name.sql
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

REM
REM Developed by Marc E. Marchioli
REM
REM inputs:
REM defaults[]
REM		field_1[]	user's tables to analyze
REM define username=&1
REM
REM		field_2[]	table_name or match string
REM define tablename=&2
REM
REM		field_3[E]	switch to 'E' or 'e' to estimate 
REM				       or 'C' or 'c' to compute
REM define compute_opt=&3
REM

set termout on
prompt
prompt ******** Running DBA Generate Analyze Script
prompt
set termout off

column buff format a130 fold_after 1

set pagesize 0
set heading off
set verify off
set feedback off
set embedded on
set termout off

spool &output_file
select
'REM Analyze script for &app_name' buff
from dual;

select
'PROMPT Analyzing table:  "'||owner||'"."'||table_name||'"' buff,
'analyze table "'||owner||'"."'||table_name||'"'||decode('&compute_opt','C',' compute statistics;'
						   ,'c',' compute statistics;'
						   ,'E',' estimate statistics;'
						   ,'e',' estimate statistics;'
						   ,' estimate statistics;') buff
from all_tables
where owner like upper('&owner')
  and table_name like upper('&prefix')
order by owner, table_name
/
select
'exit' buff
from dual;
spool off

set feedback on
set termout on
prompt
prompt ***************************************
prompt *** Analyze script file is &output_file
prompt ***
prompt *** To run simply type sqlplus dba_user @&output_file
prompt ***
rem  prompt *** To print use: a2ps -nh -nn -ns -p -f6.5 &output_file | lp
prompt ***************************************
start &tool_home/ppcmd
exit
