REM lstauact.sql checked out on 8/15/97 17:05:20 version 1.3
set termout off
REM ---- Enter the ORACLE User Name to list audit information for or wildcard to match:%
define user_name = '&1'
 
REM ---- Enter the OS User Name or wildcard to Match:%
define os_user_name = '&2'
	
REM ---- Enter the Title for the top of the report:?
define app_name = '&3'
	 
REM ---- Enter the starting time/date (for time use to_date('value','format')):sysdate-1
define start_time = '&4'
		
REM ---- Enter the ending time/date (for time use to_date('value','format')):sysdate
define end_time = '&5'
	 
REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'
	
REM ---- Var '&7' not used
 
REM ----- Home for the utils
define tool_home='/home/oracle/local/dba_rpt'
 
rem Copyright by Melanie J Burns, 1997 
rem The Database Group, Inc.
rem Created for her personal use.
rem
start &tool_home/pformat
start &tool_home/rptvars
 
set feedback off
set verify off
set heading off

set termout on
prompt
prompt ******** Running DBA List Audit Objects Report
prompt for User Name like:      &user_name
prompt and OS User Name like:   &os_user_name
prompt and transactions between &start_time and &end_time
prompt

set termout off
set heading on
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Audit Objects for User Name like &user_name and OS User Name like &os_user_name and between &start_time and &end_time'
skip 2

btitle center 'Report: lstauact'

column os_username heading 'OS|User' format a10
column username heading 'Oracle|User' format a10
column owner heading 'Owner' format a10
column action_name heading 'Action' format a12
column obj_name heading 'Object Name' format a30
column Accessed heading 'Accessed' format a18
column Action heading 'Action' format a20

set liines 180

break on owner on obj_name skip 1;

spool &output_file

select owner, obj_name, to_char(timestamp,'dd-MON-yy hh:mi:ss') Accessed, 
			 os_username, username, action_name, 
			 decode(substr(ses_actions,1,13),
							'---S---------', 'Del',
							'------S------', 'Ins',
							'---------S---', 'Sel',
							'----------S--', 'Upd',
							'---S--S------', 'Del,Ins',
							'---S--S--S---', 'Del,Ins,Sel',
							'---S--S--SS--', 'Del,Ins,Sel,Upd',
							'------S--S---', 'Ins,Sel',
							'------S--SS--', 'Ins,Sel,Upd',
							'---------SS--', 'Sel,Upd',
							'Other') Action
	from dba_audit_object
 where username like upper('&user_name')
	 and os_username like '&os_user_name'
	 and timestamp between decode('&start_time','%',sysdate-600,'&start_time') 
                           and decode('&end_time','%',sysdate+1,'&end_time')
 order by owner, obj_name, timestamp
/

spool off
start &tool_home/ppcmd
exit

