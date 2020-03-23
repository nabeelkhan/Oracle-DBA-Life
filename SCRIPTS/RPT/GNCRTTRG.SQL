REM gncrttrg.sql checked out on 9/23/97 17:05:17 version 1.6
set termout off
REM ---- Enter the Owner of the objects or wildcard to match:%
define owner = '&1'
 
REM ---- Enter the table name the trigger is on or wildcard to match:%
define prefix = '&2'
 
REM ---- Enter the Title for the top of the report:?
define app_name = '&3'
 
REM ---- Var '&4' not used
 
REM ---- Var '&5' not used
 
REM ---- Enter the Output file name for the report:$report_name.sql
define output_file='&6'
 
REM ---- Var '&7' not used
 
REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem Created by Marc E. Marchioli
rem in 1996 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
 
set feedback off
set verify off
set heading off
set pagesize 0

column buff fold_after 1
 
set termout on
prompt
prompt ******** Running DBA Generate SQL for Triggers
prompt 
prompt for owner like:       &owner
prompt and table name like: &prefix
prompt
select
'There are '||count(distinct dbt.trigger_name)||' triggers' buff,
'for owner:  ''&owner'' on tables with names like: ''&prefix''.' buff
from all_triggers dbt
where dbt.table_owner like upper('&owner')
  and dbt.table_name like upper('&prefix');

set termout off
set heading off
set arraysize 1
set long 999999

column buff fold_after 1
column  trigger_body format a130 word_wrapped
break on trigger_name skip 3 on table_name skip 3 on owner skip 3 on report

spool &output_file
select 
'REM Generated for owner like:       &owner' buff,
'REM           and table name like:  &prefix' buff,
'REM  ' buff
from dual;
select
'CREATE OR REPLACE TRIGGER '||owner||'.'||trigger_name buff,
substr(at.trigger_type,1,((instr(at.trigger_type,' ',1) -1)))||' '||triggering_event||' ON '||table_owner||'.'||table_name buff,
referencing_names||' '
||decode(instr(at.trigger_type,'ROW'), 0 , '','FOR '||substr(at.trigger_type, instr(at.trigger_type,' ',1)+1)) buff,
decode(when_clause, null,null,'WHEN ('||when_clause||')') buff,
trigger_body buff, '.' buff, '/' buff
from all_triggers at
where owner like upper('&owner') 
  and table_name like upper('&prefix')
  and trigger_name not like 'TLOG$%'
order by owner, table_owner, table_name, trigger_name, trigger_type, triggering_event;

spool off
start &tool_home/ppcmd
exit
