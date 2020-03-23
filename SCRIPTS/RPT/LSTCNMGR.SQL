REM lstcnmgr.sql version 1.2 checked out on 6/12/97 16:15:02 17:05:19
set termout off
REM ---- Enter the Concurrent Manager Name or wildcard to match:%
define manager_name = '&1'
 
REM ---- Enter the Status (Active, Deactived,  Terminated, ... ) or wildcard to Match:Active
define status = '&2'
	
REM ---- Enter the Title for the top of the report:?
define app_name = '&3'
	 
REM ---- Var '&4' not used
		
REM ---- Var '&5' not used
	 
REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'
	
REM ---- Var '&7' not used
 
REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'
 
rem Copyright by Marc E. Marchioli, 1997 
rem Created for his personal use.
rem
start &tool_home/pformat
start &tool_home/rptvars
 
set feedback off
set verify off
set heading off

set termout on
prompt
prompt ******** Running DBA List Concurrent Managers
prompt for manager name like:   &manager_name
prompt for manager status like: &status
prompt

set termout off
set heading on
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Concurrent Managers for Manager Name like ''&manager_name'' and Status like ''&status''' skip 2

btitle center 'Report: lstcnmgr'

column concurrent_queue_name heading 'Manager' format a30 word_wrapped
column meaning heading 'Status' format a15
column os_process_id heading 'OS|Process|ID' format a8
column oracle_process_id heading 'Oracle|Process|ID' format 999999


break on concurrent_queue_name on meaning skip 1

spool &output_file

select fcq.concurrent_queue_name, ls.meaning, 
       fcp.OS_PROCESS_ID, fcp.ORACLE_PROCESS_ID
from 
	applsys.fnd_concurrent_processes fcp,
	applsys.fnd_concurrent_queues fcq,
	applsys.fnd_application fa,
	applsys.fnd_lookups ls
where fa.application_id = fcq.application_id
  and fcq.application_id = fcp.queue_application_id
  and fcp.concurrent_queue_id = fcq.concurrent_queue_id
  and fcp.process_status_code = ls.lookup_code
  and ls.lookup_type = 'CP_PROCESS_STATUS_CODE'
  and fcq.concurrent_queue_name like '&manager_name'
  and ls.meaning like initcap('&status%')
order by ls.meaning, fcq.concurrent_queue_name, fcp.CONCURRENT_PROCESS_ID
/

spool off
start &tool_home/ppcmd
exit

