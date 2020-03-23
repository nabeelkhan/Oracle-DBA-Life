REM lstusrre.sql checked out on 6/25/97 17:05:20 version 1.3
set termout off
REM ---- Enter the User Name or wildcard to match:%
define user_name = '&1'
 
REM ---- Enter the Responsibility  or wildcard to Match:%
define responsibility = '&2'
	
REM ---- Enter the Title for the top of the report:?
define app_name = '&3'
	 
REM ---- Enter whether to show active only (Y) or all (N):Y
define active = '&4'
		
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
prompt ******** Running DBA List Financials 
prompt *******  User Responsiblities
prompt for User name like:      &user_name
prompt for Responsibility like: &responsibility
prompt and active only:         &active
prompt

set termout off
set heading on
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Financials Responsibilities for User Name like ''&user_name'' and Responsibility like ''&responsibility'' active only ''&active'''

btitle center 'Report: lstusrre'

column user_name heading 'User' format a30 word_wrapped
column responsibility_name heading 'Responsibility' format a35
column start_date heading 'Starts' format a17
column end_date heading 'Ends' format a17


break on responsibility_name skip 1 on user_name
alter session set nls_date_format='DD-Mon-YYYY HH24:MI';

spool &output_file

select 
			fr.responsibility_name, fu.user_name, fur.start_date, fur.end_date
from 
		 applsys.fnd_responsibility fr,
     applsys.fnd_user_responsibility fur,
		 applsys.fnd_user fu
where fu.user_name like upper('&user_name')
	and fu.user_id = fur.user_id 
	and fur.responsibility_id = fr.responsibility_id 
	and fur.application_id = fr.application_id
	and fr.responsibility_name like '&responsibility'
	and nvl(fur.end_date, sysdate+1) > decode(upper('&active'), 'Y', sysdate, '01-JAN-1900 00:00')
	and nvl(fu.end_date, sysdate+1) > decode(upper('&active'), 'Y', sysdate, '01-JAN-1900 00:00')
order by fr.responsibility_name, fu.user_name, fur.start_date, fur.end_date
/

spool off
start &tool_home/ppcmd
exit
