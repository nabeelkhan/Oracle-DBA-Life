REM lstpid.sql checked out on 6/12/97 17:05:18 version 1.10
set termout off
REM ---- Enter the ORACLE sid to search for (enter 0 for pid only or 0 for both sid and pid or all users):0
define in_sid='&1'

REM ---- Enter the ORACLE pid to search for (enter 0 for sid only or 0 for both sid and pid or all users):0
define in_pid='&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&4' not used

REM ---- Var '&5' not used

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

set feedback off
set verify off
set heading on
column in_where new_value where_clause noprint
column in_title new_value title_clause noprint
select decode(&in_pid, 0, decode(&in_sid, 0, 'vp.pid <> 0 and vs.sid <> 0','vs.sid = &in_sid'), 'vp.pid = &in_pid') in_where,
decode(&in_pid, 0, decode(&in_sid, 0, 'all users','sid = &in_sid'), 'pid = &in_pid') in_title
from dual;

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'SQL Text and other information for &title_clause'  skip 2

btitle center 'Report: lstpid'

set termout on
prompt
prompt ******** Running DBA List SQL for ORACLE
prompt &title_clause
prompt
prompt WARNING! Requires access to V$ tables owned by 'SYS'
prompt 
set termout off

column sid_pid heading 'Oracle|SID PID' format a9
column username heading User format a12
column process heading 'Operating Sys|Parent/Shadow|Process' format a15
column osuser heading 'OS User' format a10
column name heading 'Latch|Name' format a10 word_wrapped
column sql_text heading 'SQL Text' format a64 word_wrapped
break on sid_pid on username on process on spid on osuser on name skip 1

spool &output_file
select vs.sid||' '||vp.pid sid_pid, vs.username, vs.process||'/'||vp.spid process, vs.osuser||' @ '||vs.machine osuser, 
st.sql_text
from 
     v$sqltext st,
     v$session vs,
     v$process vp
where &where_clause
  and vp.addr = vs.paddr
  and vs.sql_hash_value = st.hash_value
  and vs.sql_address = st.address
order by vs.sid, vs.username, piece
/
spool off
start &tool_home/ppcmd
exit
