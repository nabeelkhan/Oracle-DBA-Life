REM lstcnapp.sql checked out on 7/24/97 17:05:20 version 1.2
set termout off
REM ---- Enter the Oracle Application Name or wildcard to match:%
define appl_name = '&1'
 
REM ---- Enter the Concurrent Program Name or wildcard to Match:%
define prog_name = '&2'
	
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
prompt ******** Running DBA List Concurrent 
prompt *******  Application Programs
prompt for Application Name like:   &appl_name
prompt for Program Name like:       &prog_name
prompt

set termout off
set heading on
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Concurrent Programs by Appication with Application Name like ''&appl_name'' and Program Nmae like ''&prog_name'''

btitle center 'Report: lstcnapp'

column application_name heading 'Application' format a40 word_wrapped
column user_concurrent_program_name heading 'Program Name' format a85 word_wrapped


break on application_name skip 1 
alter session set nls_date_format='DD-Mon-YYYY HH24:MI';

spool &output_file

select 
     application_name , fcp.user_concurrent_program_name
from
     applsys.fnd_concurrent_programs fcp,
     applsys.fnd_application fa
where fcp.application_id = fa.application_id
  and fa.application_name like '&appl_name'
	and fcp.user_concurrent_program_name like '&prog_name'
order by application_name, user_concurrent_program_name
/

spool off
start &tool_home/ppcmd
exit

