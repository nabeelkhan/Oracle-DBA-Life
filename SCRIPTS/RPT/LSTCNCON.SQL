REM lstcncon.sql checked out on 8/11/97 17:05:20 version 1.3
set termout off
REM ---- Enter whether to look at jobs running in concurrent manager (1), or enter a specific program name:%
define prog_name = '&1'

REM ---- Var '&2' not used

REM ---- Enter the Title for the top of the report:?
define app_name ='&3'

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter the name of the Output file for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ---- Home for the utils
define tool_home='/home/oracle/local/dba_rpt'

rem
rem Created by Adam L. Levine
rem Copyright 1997 by the DataBase Group, Inc.
start &tool_home/pformat
start &tool_home/rptvars

column sql_txt new_value sql_txt noprint
column prompt_txt new_value prompt_txt noprint

select 
decode('&prog_name', '1', 
'and (fcp1.application_id, fcp1.concurrent_program_id) in (select fcrs.program_application_id, fcrs.concurrent_program_id  from applsys.fnd_concurrent_requests fcrs where fcrs.phase_code=''R'' and fcrs.status_code=''R'')', 
'and (fcp1.application_id, fcp1.concurrent_program_id) in (select fcpss.application_id, fcpss.concurrent_program_id from applsys.fnd_concurrent_programs fcpss where fcpss.user_concurrent_program_name like (''&prog_name''))') sql_txt,
decode('&prog_name', 
				'1', 'for jobs currently running in Concurrent Manager', 
							'for Concurrent Program Name like ''&prog_name''') prompt_txt
from dual;

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 - 
center 'Incompatible Programs &prompt_txt' skip 2

btitle center 'Report: lstcncon'

set termout on
prompt
prompt ********* Running Incompatible Concurrent Programs Report
prompt &prompt_txt
prompt
set termout off

set verify off
set feedback off

column running heading 'Running Program'
column running format a59 truncate

column conflict heading 'Incompatible Program'
column conflict format a59 truncate

column flag heading 'Run|Alone?'
column flag format a6

break on running on flag skip 1

spool &output_file

select fcp1.user_concurrent_program_name running,
       fcp1.run_alone_flag flag,
       fcp.user_concurrent_program_name conflict
from
       applsys.fnd_concurrent_programs fcp,
       applsys.fnd_concurrent_program_serial fcps,
       applsys.fnd_concurrent_programs fcp1
where fcp1.application_id         = fcps.running_application_id
  and fcp1.concurrent_program_id  = fcps.running_concurrent_program_id
  and fcps.to_run_application_id  = fcp.application_id
  and fcps.to_run_concurrent_program_id = fcp.concurrent_program_id &sql_txt
order by fcp.concurrent_program_name;

Spool off
start &tool_home/ppcmd
exit
