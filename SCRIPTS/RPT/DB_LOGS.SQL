REM db_logs.sql checked out on 6/12/97 17:05:13 version 1.6
set termout off
REM ---- Var &1 not used

REM ---- Enter the name of the log member or wildcard to match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&4' not used 

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
center 'Database Redo Logs Defined with Names like &prefix' skip 2

btitle center 'Report: db_logs'

set termout on
prompt
prompt ******** Running DBA Redo Logs Defined
prompt
set termout off

set feedback off
set verify off

column  group#		heading 'Group Number'			format 999999990
column  member		heading 'Redo Log Member Name'		format a75		word_wrapped
column  status		heading 'Status'			format a7 
column  bytes		heading 'Bytes'				format 999,999,999
column  archived        heading 'Archived'			format a8

break on report on group# skip 1

spool &output_file
   
select 
  lf.group#,
  nvl(lf.status,'IN USE') status,
  l.bytes,
  l.archived,
  lf.member
from v$log l,
     v$logfile lf
where lf.group# = l.group#
  and member like '&prefix'
order by group#,member
;
spool off 
start &tool_home/ppcmd
exit
