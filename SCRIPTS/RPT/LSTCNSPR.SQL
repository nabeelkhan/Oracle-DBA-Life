REM lstcnspr.sql checked out on 6/16/97 17:05:19 version 1.2
set termout off
REM ---- Enter the Concurrent Manager Name or wildcard to match:%
define manager_name = '&1'
 
REM ---- Enter the Financial Application Name or wildcard to match:%
define application_name = '&2'
 
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
prompt ******** Running DBA List Concurrent Manager 
prompt ********     Specialization Rules
prompt for manager name like:      &manager_name
prompt and application name like:  &application_name
prompt
 
set termout off
set heading on
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Concurrent Manager Specialization Rules for  Manager Name like ''&manager_name''' skip 2

btitle center 'Report: lstcnspr'

column concurrent_queue_name heading 'Manager' format a20 word_wrapped
column action heading 'Action' format a8
column application_name heading 'Application/Object' format a30 word_wrapped
column object_name heading 'Program or Object' format a50 word_wrapped
column type heading 'Type' format a12 word_wrapped

break on concurrent_queue_name skip 2 on Action skip 1 on application_name on type skip 1

spool &output_file

SELECT fcq.concurrent_queue_name, decode(INCLUDE_FLAG, 'I', 'Allow', 'E', 'Disallow') Action,
	fa.application_name, fl.meaning Type, fcp.user_concurrent_program_name object_name
FROM
	applsys.fnd_lookups fl,
	applsys.FND_APPLICATION fa,
	applsys.fnd_concurrent_programs fcp,
	applsys.FND_CONCURRENT_QUEUES fcq,
	applsys.FND_CONCURRENT_QUEUE_CONTENT fcqc
WHERE fcqc.type_application_id = fa.application_id 
  and fcqc.concurrent_queue_id = fcq.concurrent_queue_id
  and fcp.concurrent_program_id = fcqc.type_id
  and fcq.concurrent_queue_name like '&manager_name'
  and fa.application_name like '&application_name'
  and FL.LOOKUP_TYPE = 'CP_SPECIAL_RULES' 
  and FL.LOOKUP_CODE NOT IN ('G', 'L') 
  and FL.ENABLED_FLAG = 'Y' AND SYSDATE BETWEEN NVL(FL.START_DATE_ACTIVE,SYSDATE) 
  and NVL(FL.END_DATE_ACTIVE, SYSDATE)
  and  LOOKUP_CODE = fcqc.type_code
  and fcqc.type_code = 'P'
union
SELECT fcq.concurrent_queue_name, decode(INCLUDE_FLAG, 'I', 'Allow', 'E', 'Disallow') Action,
	 fa.application_name, fl.meaning Type, fcrc.request_class_name object_name
FROM
	applsys.fnd_lookups fl,
	applsys.FND_APPLICATION fa,
	applsys.fnd_concurrent_request_class fcrc,
	applsys.FND_CONCURRENT_QUEUES fcq,
	applsys.FND_CONCURRENT_QUEUE_CONTENT fcqc
WHERE fcqc.type_application_id = fa.application_id 
  and fcqc.concurrent_queue_id = fcq.concurrent_queue_id
  and fcrc.request_class_id = fcqc.type_id
  and fcqc.type_application_id = fcrc.application_id
  and fcq.concurrent_queue_name like '&manager_name'
  and fa.application_name like '&application_name'
  and FL.LOOKUP_TYPE = 'CP_SPECIAL_RULES' 
  and FL.LOOKUP_CODE NOT IN ('G', 'L') 
  and FL.ENABLED_FLAG = 'Y' AND SYSDATE BETWEEN NVL(FL.START_DATE_ACTIVE,SYSDATE) 
  and NVL(FL.END_DATE_ACTIVE, SYSDATE)
  and  LOOKUP_CODE = fcqc.type_code
  and fcqc.type_code = 'R'
union
SELECT fcq.concurrent_queue_name, decode(INCLUDE_FLAG, 'I', 'Allow', 'E', 'Disallow') Action,
	 fa.application_name, fl.meaning Type, fccr.complex_rule_name object_name
FROM
	applsys.fnd_lookups fl,
	applsys.FND_APPLICATION fa,
	applsys.fnd_concurrent_complex_rules fccr,
	applsys.FND_CONCURRENT_QUEUES fcq,
	applsys.FND_CONCURRENT_QUEUE_CONTENT fcqc
WHERE fcqc.type_application_id = fa.application_id 
  and fcqc.concurrent_queue_id = fcq.concurrent_queue_id
  and fccr.complex_rule_id = fcqc.type_id
  and fcqc.type_application_id = fccr.application_id
  and fcq.concurrent_queue_name like '&manager_name'
  and fa.application_name like '&application_name'
  and FL.LOOKUP_TYPE = 'CP_SPECIAL_RULES' 
  and FL.LOOKUP_CODE NOT IN ('G', 'L') 
  and FL.ENABLED_FLAG = 'Y' AND SYSDATE BETWEEN NVL(FL.START_DATE_ACTIVE,SYSDATE) 
  and NVL(FL.END_DATE_ACTIVE, SYSDATE)
  and  LOOKUP_CODE = fcqc.type_code
  and fcqc.type_code = 'C'
union
SELECT fcq.concurrent_queue_name, decode(INCLUDE_FLAG, 'I', 'Allow', 'E', 'Disallow') Action,
	fa.application_name, fl.meaning Type, fccs.concurrent_conflict_set_name object_name
FROM
	applsys.fnd_lookups fl,
	applsys.FND_APPLICATION fa,
	applsys.fnd_concurrent_conflict_sets fccs,
	applsys.FND_CONCURRENT_QUEUES fcq,
	applsys.FND_CONCURRENT_QUEUE_CONTENT fcqc
WHERE fcqc.type_application_id = fa.application_id 
  and fcqc.concurrent_queue_id = fcq.concurrent_queue_id
  and fccs.concurrent_conflict_set_id = fcqc.type_id
  and fccs.application_id = fcqc.type_application_id
  and fcq.concurrent_queue_name like '&manager_name'
  and fa.application_name like '&application_name'
  and FL.LOOKUP_TYPE = 'CP_SPECIAL_RULES' 
  and FL.LOOKUP_CODE NOT IN ('G', 'L') 
  and FL.ENABLED_FLAG = 'Y' AND SYSDATE BETWEEN NVL(FL.START_DATE_ACTIVE,SYSDATE) 
  and NVL(FL.END_DATE_ACTIVE, SYSDATE)
  and  LOOKUP_CODE = fcqc.type_code
  and fcqc.type_code = 'L'
union
SELECT fcq.concurrent_queue_name, decode(INCLUDE_FLAG, 'I', 'Allow', 'E', 'Disallow') Action,
	fa.application_name, fl.meaning Type, fou.oracle_username object_name
FROM
	applsys.fnd_lookups fl,
	applsys.FND_APPLICATION fa,
	applsys.fnd_oracle_userid fou,
	applsys.FND_CONCURRENT_QUEUES fcq,
	applsys.FND_CONCURRENT_QUEUE_CONTENT fcqc
WHERE fcqc.concurrent_queue_id = fcq.concurrent_queue_id
  and fou.oracle_id = fcqc.type_id
  and fa.application_short_name = fou.oracle_username
  and fcq.concurrent_queue_name like '&manager_name'
  and fa.application_name like '&application_name'
  and FL.LOOKUP_TYPE = 'CP_SPECIAL_RULES' 
  and FL.LOOKUP_CODE NOT IN ('G', 'L') 
  and FL.ENABLED_FLAG = 'Y' AND SYSDATE BETWEEN NVL(FL.START_DATE_ACTIVE,SYSDATE) 
  and NVL(FL.END_DATE_ACTIVE, SYSDATE)
  and  LOOKUP_CODE = fcqc.type_code
  and fcqc.type_code = 'O'
union
SELECT fcq.concurrent_queue_name, decode(INCLUDE_FLAG, 'I', 'Allow', 'E', 'Disallow') Action,
	fu.description application_name, fl.meaning Type, fu.user_name object_name
FROM
	applsys.fnd_lookups fl,
	applsys.fnd_user fu,
	applsys.FND_CONCURRENT_QUEUES fcq,
	applsys.FND_CONCURRENT_QUEUE_CONTENT fcqc
WHERE fcqc.concurrent_queue_id = fcq.concurrent_queue_id
  and fu.user_id = fcqc.type_id
  and fcq.concurrent_queue_name like '&manager_name'
  and FL.LOOKUP_TYPE = 'CP_SPECIAL_RULES' 
  and FL.LOOKUP_CODE NOT IN ('G', 'L') 
  and FL.ENABLED_FLAG = 'Y' AND SYSDATE BETWEEN NVL(FL.START_DATE_ACTIVE,SYSDATE) 
  and NVL(FL.END_DATE_ACTIVE, SYSDATE)
  and  LOOKUP_CODE = fcqc.type_code
  and fcqc.type_code = 'U'
order by 1, 2, 3, 4, 5
/
spool off
start &tool_home/ppcmd
exit
