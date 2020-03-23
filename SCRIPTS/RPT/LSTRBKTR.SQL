REM lstrbktr.sql checked out on 6/12/97 17:05:19 version 1.4
set termout off
REM ---- Enter the rollback segment being used or wildcard to match:%
define rollback_seg = '&1'

REM ---- Enter the Oracle User name or wildcard to match:%
define ora_user = '&2'

REM ---- Enter Title for the top of the report:?
define app_name = '&3'

REM ---- Enter the Operating system user id (case sensitive) or wildcard to match:%
define os_user = '&4'

REM ---- Var '&5' not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var &7 not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1996 For his personal use
rem Copyright 1996 The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Oracle Processes assigned to a rollback segment with name like &rollback_seg and User names like &ora_user and OS User names like &os_user' skip 2

btitle center 'Report: lstrbktr'

set termout on
prompt
prompt ******** Transactions for a Rollback Segment
prompt      for &app_name
prompt      with rollback segment name like  &rollback_seg
prompt       and OS user name like           &os_user
prompt       and ORACLE user name like       &ora_user
prompt
set termout off

set feedback off
set verify off
set heading on


column name heading 'Rollback Seg' format a12
column username heading 'User/OS User' format a20
column sql_text heading 'SQL Text' format a65 word_wrapped

break on report on name skip 2 on username skip 1

spool &output_file
select vr.name, vs.username||'/'||osuser username, st.sql_text
from
        v$rollname vr,
        v$session vs,
        v$sqltext st,
        v$transaction vt
where vr.name like upper('&rollback_seg')
  and vs.username like upper('&ora_user')
  and vs.osuser like '&os_user'
  and vr.usn = vt.xidusn
  and vt.addr = vs.taddr
  and st.hash_value (+) = vs.sql_hash_value
order by 1,2, piece
/
spool off
start &tool_home/ppcmd
exit
