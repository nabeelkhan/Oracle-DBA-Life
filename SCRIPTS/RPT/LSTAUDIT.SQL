REM lstaudit.sql checked out on 6/12/97 17:05:18 version 1.4
set termout off
REM ---- Enter the User Name to list audit information for or the wildcard to match:%
define user_name='&1'

REM ---- Enter the OS User name or wildcard to Match:%
define os_user_name='&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter the starting time/date (for time use to_date('value', 'format')):sysdate-1
define start_time='&4'

REM ---- Enter the ending time/date (for time use to_date('value', 'format')):sysdate
define end_time='&5'

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1996 For his personal use
rem Copyright 1995 The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Audit Trail for User Name like &user_name and OS User Name like &os_user_name and between &start_time and &end_time' skip 2

btitle center 'Report: lstaudit'

set feedback off
set verify off
set heading on

set termout on
prompt
prompt ******** Running DBA List Audit Trail Results Report
prompt for User Name like:      &user_name
prompt and OS User Name like:   &os_user_name
prompt and transactions between &start_time and &end_time
prompt 
set termout off

column os_username heading 'OS|User Name' format a10
column username heading 'User Name' format a12
column connect_time heading 'Log on Time' format a18
column minutes_on heading 'Minutes|Connected' format 999,990.99
column logoff_lread heading 'Logical|Blocks|Read' format 999,999,990
column logoff_pread heading 'Physical|Blocks|Read' format 999,999,990
column logoff_lwrite heading 'Logical|Blocks|Written' format 999,999,990

spool &output_file
select os_username, username, to_char(timestamp, 'DD-Mon-YYYY HH24:MI') connect_time,
(logoff_time-timestamp)*1440 minutes_on, logoff_lread, logoff_pread, logoff_lwrite
from dba_audit_session
where logoff_time is not null
  and username like '&user_name'
  and os_username like '&os_user_name'
  and timestamp between &start_time and &end_time
order by logoff_lread desc, logoff_pread desc, logoff_lwrite desc, os_username, username
/
spool off
start &tool_home/ppcmd
exit
