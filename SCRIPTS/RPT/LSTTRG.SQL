REM lsttrg.sql checked out on 12/22/97 17:05:21 version 1.1 created on 8/27/97 13:08:38
set termout on
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the table name or wildcard to match:%
define tab_name = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter the Owner of triggers or wildcard to match:%
define trig_own = '&4'

REM ---- Enter the name of the trigger or wildcard to match:%
define trig_name = '&5'

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Adam Levine
rem Copyright 1997 by the DataBase Group, Inc.
rem

start &tool_home/pformat
start &tool_home/rptvars

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Defined Triggers for Table Owners like &owner and Table Names like &tab_name' skip 1 -
center 'Matching Trigger Owners like &trig_own and Trigger Names like &trig_name'  skip 2

btitle center 'Report: lsttrg'

set termout on
prompt
prompt ******** Running DBA List Triggers Report
prompt for table owner   like: &owner
prompt and table name    like: &tab_name
prompt and trigger owner like: &trig_own
prompt and trigger name  like: &trig_name
prompt
set termout off

set arraysize 1
set long 999999

set feedback off
set verify off

column name heading 'Trigger Name' format a25 word_wrapped
column buff heading 'Trigger Conditions' format a30 word_wrapped
column trigger_body heading 'Trigger Body' format a65 word_wrapped

break on t_name on t_owner on owner on name skip 2

spool &output_file

select owner||'.'||trigger_name name, 
      substr(alltrg.trigger_type,1,((instr(alltrg.trigger_type,' ',1) -1)))||' '||triggering_event||' ON '||table_owner||'.'||table_name ||' '||
      referencing_names||' FOR '||substr(alltrg.trigger_type,instr(alltrg.trigger_type,' ',1)+1, decode(instr(alltrg.trigger_type,'ROW',1) +2,2,1,instr(alltrg.trigger_type,'ROW',1)+2)) ||' '||
      decode(when_clause, null, null, 'WHEN ('||when_clause||')') buff,
      trigger_body
from
       all_triggers alltrg
where
       alltrg.table_owner  like upper('&owner')
   and alltrg.table_name   like upper('&tab_name')
   and alltrg.owner        like upper('&trig_own')
   and alltrg.trigger_name like upper('&trig_name')
order by
       alltrg.table_owner, alltrg.table_name, 
       alltrg.owner, alltrg.trigger_name;


spool off
start &tool_home/ppcmd
#exit
