REM lstcnjob.sql version 1.5 checked out on 9/22/97 17:17:59 17:05:19
set termout off
REM ---- Enter the Concurrent Manager Name or wildcard to match:%
define manager_name = '&1'
 
REM ---- Enter the Manager Status (Active, Deactived,  Terminated, ... ) or wildcard to Match:Active
define mgr_status = '&2'
	
REM ---- Enter the Title for the top of the report:?
define app_name = '&3'
	 
REM ---- Enter the job status (Running, Pending, ...) or wildcard to match:Running
define job_status = '&4'
		
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
prompt ******** Running DBA List Concurrent Manager Jobs
prompt for manager name like:   &manager_name
prompt and manager status like: &mgr_status
prompt and job status like:     &job_status
prompt

set termout off
set heading on
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Concurrent Managers for Manager Name like ''&manager_name'' and Manager Status like ''&mgr_status'' and job status like ''&job_status''' skip 2

btitle center 'Report: lstcnjob'

column concurrent_queue_name heading 'Manager' format a20 word_wrapped
column meaning heading 'Mgr. Status' format a13
column os_process_id heading 'OS|Process|ID' format a8
column oracle_process_id heading 'Oracle|Process|ID' format 999999
column start_date heading 'Start' format a14
column REQUESTED_BY heading 'Requested|By' format a9
column user_concurrent_program_name heading 'Program Name' format a23 word_wrapped
column job_status heading 'Job Status' format a10
column request_id heading 'Request|ID' format 9999999


break on concurrent_queue_name on meaning on os_process_id on oracle_process_id on job_status on user_concurrent_program_name skip 1

spool &output_file

select fcq.concurrent_queue_name, ls.meaning, fcr.request_id,
       fcp.OS_PROCESS_ID, fcp.ORACLE_PROCESS_ID, ls2.meaning job_status,
       fcpg.user_concurrent_program_name, usr.user_name requested_by, 
       to_char(fcr.actual_start_date, 'MM/DD/YY HH24:MI') start_date
from 
	applsys.fnd_concurrent_programs fcpg,
	applsys.fnd_concurrent_requests fcr,
	applsys.fnd_concurrent_processes fcp,
	applsys.fnd_concurrent_queues fcq,
	applsys.fnd_application fa,
	applsys.fnd_lookups ls,
	applsys.fnd_lookups ls2,
	applsys.fnd_user usr
where fa.application_id = fcq.application_id
  and fcq.application_id = fcp.queue_application_id
  and fcp.concurrent_queue_id = fcq.concurrent_queue_id
  and fcp.process_status_code = ls.lookup_code
  and ls.lookup_type = 'CP_PROCESS_STATUS_CODE'
  and fcq.concurrent_queue_name like '&manager_name'
  and ls.meaning like initcap('&mgr_status%')
  and fcp.concurrent_process_id = fcr.controlling_manager
  and fcpg.application_id = fcr.program_application_id
  and fcpg.concurrent_program_id = fcr.concurrent_program_id
  and fcr.requested_by = usr.user_id
  and fcr.phase_code = ls2.lookup_code
  and ls2.lookup_type = 'CP_PHASE_CODE'
  and fcr.phase_code in (select ls1.lookup_code
			 from applsys.fnd_lookups ls1
			 where ls1.meaning like initcap('&job_status%')
			   and ls1.lookup_type = 'CP_PHASE_CODE')
order by ls.meaning, fcq.concurrent_queue_name, actual_start_date desc
/
spool off
start &tool_home/ppcmd
exit
