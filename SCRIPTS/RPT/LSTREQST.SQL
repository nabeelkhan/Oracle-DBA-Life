REM lstreqst.sql checked out on 12/22/97 17:05:19 version 1.3 created on 12/19/97 16:10:32
set termout off
REM ---- Enter the Concurrent Program Name or wildcard to Match:%
define prog_name = '&1'
 
REM ---- Enter the offset (days) from today's date for the start of the sample period:7
define start_date = '&2'
	
REM ---- Enter the Title for the top of the report:?
define app_name = '&3'
	 
REM ---- Enter the offset (days) from today's date for the end of the sample period:0
define end_date = '&4'
		
REM ---- Enter order by preference (1 => program name, 2 => # runs, 3 => avg run time):1
define order_pref = &5
	 
REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'
	
REM ---- Var '&7' not used
 
REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'
 
rem Created by Marc E. Marchioli, 6/27/1997 
rem Copyright by The DataBase Group, Inc., 1997
rem 
start &tool_home/pformat
start &tool_home/rptvars
 
set feedback off
set verify off
set heading off

column order_txt new_value order_by noprint
column order_ptxt new_value order_prompt noprint

select 
decode(&order_pref, 1, 'user_concurrent_program_name', 2, 'times_run desc', 3, 'avg_run_time desc', 
'user_concurrent_program_name') order_txt,
decode(&order_pref, 1, 'Program Name', 2, 'Number of runs descending', 3, 'Average Run Time descending', 
'Program Name') order_ptxt
from dual;

set termout on
prompt
prompt ******** Running DBA List Completed Concurrent 
prompt *******  Program Run Statistics
prompt for Program Name like:       &prog_name
prompt and from   sysdate-&start_date   to   sysdate-&end_date
prompt and ordered by  &order_prompt
prompt

set termout off
set heading on
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Concurrent Programs Run Statistics for Program Name like ''&prog_name'' from &start_date days ago to &end_date days ago' skip1 -
center 'order by &order_prompt' skip 2

btitle center 'Report: lstreqst'

column user_concurrent_program_name heading 'Program Name' format a50 word_wrapped
column times_run heading 'Number of|Completed|Runs' format 9,999,990
column problems heading 'Runs with|Errors or|Warnings' format 9,999,990
column max_run_time heading 'Max Run|Time|(hours)' format 990.90
column min_run_time heading 'Min Run|Time|(hours)' format 990.90
column avg_run_time heading 'Avg Run|Time|(hours)' format 990.90
column min_start heading 'Earliest|Start|Date' format a11
column max_start heading 'Latest|Start|Date' format a11


compute sum of times_run on report
compute sum of problems on report
break on report

spool &output_file

select 
	fcp.user_concurrent_program_name, count(fcr.request_id) times_run, 
	sum(decode(ltrim(rtrim(ls2.meaning)), 'Error', 1, 'Warning', 1, 0)) problems,
	max(actual_completion_date - actual_start_date)*24 max_run_time,
	min(actual_completion_date - actual_start_date)*24 min_run_time,
	avg(actual_completion_date - actual_start_date)*24 avg_run_time,
	min(actual_start_date) min_start,
	max(actual_start_date) max_start
from
     applsys.fnd_concurrent_programs fcp,
     applsys.fnd_lookups ls2,
     applsys.fnd_concurrent_requests fcr
where fcp.concurrent_program_id = fcr.concurrent_program_id
  and fcp.application_id = fcr.program_application_id
  and fcp.user_concurrent_program_name like '&prog_name'
  and phase_code in (select ls1.lookup_code
			 from applsys.fnd_lookups ls1
			 where ls1.meaning like 'Completed%'
			 and ls1.lookup_type = 'CP_PHASE_CODE')
  and status_code = ls2.lookup_code
  and ls2.lookup_type = 'CP_STATUS_CODE'
  and actual_start_date >= sysdate - &start_date
  and actual_completion_date <= sysdate - &end_date
group by user_concurrent_program_name
order by &order_by
/

spool off
start &tool_home/ppcmd
exit

