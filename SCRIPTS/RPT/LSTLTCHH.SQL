REM lstltchh.sql checked out on 10/18/97 17:05:18 version 1.8
set termout off
REM ---- Var '&1' not used

REM ---- Var '&2' not used

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
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'SQL Text and other information for User holding latch in V$LATCHHOLDER'  skip 2

btitle center 'Report: lstltchh'

set feedback off
set verify off
set heading on

set termout on
prompt
prompt ******** Running DBA List Latch Holder 
prompt
prompt WARNING! Requires access to V$ tables owned by 'SYS'
prompt 
set termout off

column sid_pid heading 'Oracle|SID PID' format a9
column username heading User format a12
column process heading 'Operating Sys|Parent/Shadow|Process' format a13
column osuser heading 'OS User' format a8
column name heading 'Latch|Name' format a10 word_wrapped
column sql_text heading 'SQL Text' format a64 word_wrapped
break on sid_pid on username on process on spid on osuser on name skip 1

spool &output_file
select vs.sid||' '||vp.pid sid_pid, vs.username, vs.process||'/'||vp.spid process, vs.osuser||' @ '||vs.machine osuser, 
vl.name, sa.sql_text
from 
     v$sqlarea sa,
     v$session vs,
     v$session_wait vsw,
     v$process vp,
     v$latch vl,
     v$latchholder vlh
where vs.sid = vsw.sid
  and vlh.pid = vp.pid
  and vp.addr = vs.paddr
  and vs.sql_hash_value = sa.hash_value
  and vs.sql_address = sa.address
  and vlh.laddr = vl.addr
order by vs.sid, vs.username
/
spool off
start &tool_home/ppcmd
exit
