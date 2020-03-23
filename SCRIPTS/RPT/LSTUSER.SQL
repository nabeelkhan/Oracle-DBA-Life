REM lstuser.sql version 1.3 checked out on 10/18/97 10:50:15 17:05:20
set termout off
REM ---- Enter the ORACLE sid to search for (enter 0 for pid only or 0 for both sid and pid or all users):0
define in_sid='&1'

REM ---- Enter the ORACLE pid to search for (enter 0 for sid only or 0 for both sid and pid or all users):0
define in_pid='&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter the OS Parent process ID (enter 0 for any or to use shadow pid):0
define os_parent_id='&4'

REM ---- Enter the OS Shadow process ID (enter 0 for any or to use parent pid):0
define os_shadow_id='&5'

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem July 21, 1997 
rem Copyright 1997 The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars

set feedback off
set verify off
set heading on
column in_where new_value where_clause noprint
column in_title new_value title_clause noprint
select 
decode(&in_pid, 0, decode(&in_sid, 0, 'vp.pid <> 0 and vs.sid <> 0','vs.sid = &in_sid'), 'vp.pid = &in_pid') 
||decode(&os_parent_id, 0, decode(&os_shadow_id, 0, '','and vp.spid = ''&os_shadow_id'''), 'and vs.process = ''&os_parent_id''') in_where,
decode(&in_pid, 0, decode(&in_sid, 0, 'users','sid = &in_sid'), 'pid = &in_pid')
||' and '||decode(&os_parent_id, 0, decode(&os_shadow_id, 0, 'processes','shadow = &os_shadow_id'), 'with OS parent process id = &os_parent_id') in_title
from dual;

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Parent and Shadow process information for &title_clause'  skip 2

btitle center 'Report: lstuser'

set termout on
prompt
prompt ******** Running DBA List User for ORACLE
prompt &title_clause
prompt
prompt WARNING! Requires access to V$ tables owned by 'SYS'
prompt 
set termout off

column sid_pid heading 'Oracle|SID PID' format a9
column username heading User format a12
column process heading 'Operating System|Parent/Shadow|Process' format a25
column osuser heading 'OS User' format a30
column program heading 'Program' format a30
break on sid_pid on username on process on spid on osuser on name skip 1

spool &output_file
select vs.sid||' '||vp.pid sid_pid, vs.username, vs.process||'/'||vp.spid process, vs.osuser||' @ '||vs.machine osuser,
vs.program
from 
     v$session vs,
     v$process vp
where &where_clause
  and vp.addr = vs.paddr
order by vs.sid, vs.username
/
spool off
start &tool_home/ppcmd
exit
