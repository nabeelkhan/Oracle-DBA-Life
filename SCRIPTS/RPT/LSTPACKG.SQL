REM lstpackg.sql checked out on 10/18/97 17:05:18 version 1.7
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
set pagesize 0

column buff fold_after 1
 
set termout on
prompt
prompt ******** Running DBA List Package 
prompt Generating list of defined packages
prompt for owner like:       &owner
prompt and package name like: &prefix
prompt
select
'There are '||count(distinct dbt.owner||dbt.name)||' objects' buff,
'for owner:  ''&owner'' with names like: ''&prefix''.' buff
from all_source dbt
where dbt.owner like upper('&owner')
  and dbt.type in ('PACKAGE','PROCEDURE','FUNCTION')
  and dbt.name like upper('&prefix');

set termout off
set heading off

column type noprint
column name noprint
break on type skip 3 on name skip 3

spool &output_file
select owner||'.'||decode(type,'PACKAGE',1,'PACKAGE BODY',2, 'PROCEDURE', 3, 'FUNCTION',4) type, name, text
from all_source 
where owner like upper('&owner')
  and name like upper('&prefix')
  and type in ('PACKAGE','PACKAGE BODY','FUNCTION','PROCEDURE')
order by owner, type, name , line;

spool off
start &tool_home/ppcmd
exit
