REM lst_snap.sql checked out on 6/12/97 17:05:17 version 1.4
set termout off
REM ---- Enter the Owner of the objects or wildcard to match:%
define owner = '&1'
 
REM ---- Enter the object name or wildcard to Match:%
define prefix = '&2'
 
REM ---- Enter the Title for the top of the report:?
define app_name = '&3'
 
REM ---- Var '&4' not used
 
REM ---- Var '&5' not used
 
REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'
 
REM ---- Var '&7' not used
 
REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem Created by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
 
set feedback off
set verify off
set heading off

column buff fold_after 1
 
set termout on
prompt
prompt ******** Running DBA List Snapshots 
prompt Generating list of defined snapshots
prompt for owner like:       &owner
prompt and object name like: &prefix
prompt
select
'There are '||count(dbt.object_name)||' objects' buff,
'for owner:  ''&owner'' with names like: ''&prefix''.' buff
from all_objects dbt
where dbt.owner like upper('&owner')
  and dbt.object_name like upper('SNAP$_&prefix');

set termout off
set heading on
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Snapshots Defined for Owner like &owner and Snapshot Names like &prefix' skip 2

btitle center 'Report: lst_snap'

column query heading 'Query' format a22 word_wrapped
column name heading 'Name' format a30 word_wrapped
column start_with heading 'Sched|Refresh' format a14
column next heading 'Next|Refresh' format a25 word_wrapped
column last_refresh heading 'Last|Refresh' format a14

spool &output_file

select owner||'.'||name name,to_char(last_refresh, 'MM/DD/YY HH24:MI') last_refresh,
can_use_log,type,next,to_char(start_with, 'MM/DD/YY HH24:MI') start_with,query
from dba_snapshots
where owner like upper('&owner')
  and name like upper('&prefix')
order by owner,name;

spool off
start &tool_home/ppcmd
exit
