REM lstcncur.sql checked out on 7/24/97 17:05:17 version 1.9
set termout off
REM ---- Enter the Requestor of the job or wildcard to match:%
define requested_by = '&1'
 
REM ---- Enter the Phase (Running, Pending, ... ) or wildcard to Match:Running
define phase = '&2'
 
REM ---- Enter the Title for the top of the report:?
define app_name = '&3'
 
REM ---- Enter the Status (Normal, Standby, Scheduled, ...) or wildcard to Match:%
define status = '&4'

REM ---- Enter the Concurrent Manager Request id or 0 for all requests:0
define request_id = '&5'
 
REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Enter the application program name (case sensitive) or wildcard to Match:%
define prog_name = '&7'
 
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

column buff fold_after 1
column request_where_txt new_value request_where noprint
select decode('&request_id', '0', '', 'and request_id = &request_id') request_where_txt
from dual;
 
set termout on
prompt
prompt ******** Running DBA List Concurrent Requests 
prompt for Phase like:          &phase
prompt and status like:         &status
prompt for requested by like:   &requested_by
prompt and program name like:   &prog_name
prompt &request_where
prompt

set termout off
set heading on
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Concurrent Requests for Requested by like ''&requested_by'' and Phase like ''&phase'' and Status like ''&status''' skip 1 -
center 'and program name like ''&prog_name''' skip 2

btitle center 'Report: lstcncur'

column request_id heading 'Request' format 9999999
column phase heading 'Phase' format a9 word_wrapped
column status heading 'Status' format a9 word_wrapped
column priority heading 'Pri' format 999
column user_concurrent_program_name heading 'Program Name' format a35 word_wrapped
column REQUESTED_BY heading 'Requested|By' format a9
column priority_request_id noprint
column parent_request_id heading 'Parent ID' 
column completion_text heading 'Completion|Text' format a15 word_wrapped
column start_date heading 'Start' format a14
column complete_date heading 'End' format a14


spool &output_file
SELECT REQUEST_ID, decode(hold_flag,'Y','Inactive', lp.meaning) Phase, 
decode(hold_flag, 'Y', 'On Hold', ls.meaning) Status, PRIORITY, cp.user_concurrent_program_name, 
usr.user_name REQUESTED_BY, PARENT_REQUEST_ID,  to_char(actual_start_date, 'MM/DD/YY HH24:MI') start_date,
to_char(actual_completion_date, 'MM/DD/YY HH24:MI') complete_date
FROM
 applsys.FND_CONCURRENT_REQUESTS cr,
 applsys.fnd_concurrent_programs cp,
 applsys.fnd_user usr,
 applsys.fnd_lookups ls,
 applsys.fnd_lookups lp
where phase_code in (select ls1.lookup_code 
		      from applsys.fnd_lookups ls1 
		      where ls1.meaning like decode('&phase','','%',
								   decode(initcap('&phase'), 'Inactive', 'Pending%', initcap('&phase'||'%')))
			and ls1.lookup_type = 'CP_PHASE_CODE'
		      )
  and status_code in (select ls1.lookup_code
                      from applsys.fnd_lookups ls1
                      where ls1.meaning like decode('&status','','%',
								    decode(initcap('&status'), 'On Hold', 'Normal%', initcap('&status'||'%')))
                        and ls1.lookup_type = 'CP_STATUS_CODE'
                      )
  and cp.concurrent_program_id = cr.concurrent_program_id
  and cp.application_id = cr.program_application_id
  and cr.requested_by = usr.user_id
  and usr.user_name like decode('&requested_by','','%',upper('&requested_by'))
  and cp.user_concurrent_program_name like '&prog_name'
  and lp.lookup_type = 'CP_PHASE_CODE'
  and lp.lookup_code = phase_code
  and ls.lookup_type = 'CP_STATUS_CODE'
  and ls.lookup_code = status_code  &request_where
  and cr.hold_flag like decode(initcap('&phase'), 'Inactive', 'Y', decode(initcap('&status'),'On Hold', 'Y', '%'))
order by actual_start_date desc
/
spool off
start &tool_home/ppcmd
exit
