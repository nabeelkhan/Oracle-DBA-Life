REM lstslock.sql checked out on 6/12/97 17:05:19 version 1.3
set termout off
REM ---- Var &1 not used

REM ---- Var &2 not used

REM ---- Enter Title for the top of the report:?
define app_name = '&3'

REM ---- Var &4 not used

REM ---- Var '&5' not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var &7 not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1996 For The DataBase Group, Inc.
rem Copyright 1996 The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Locks being held which may be dependent on another process (tertiary locks may not appear)' skip 2

btitle center 'Report: lstslock'

set termout on
prompt
prompt ******** Dependent Locks
prompt      for &app_name
prompt
set termout off

set feedback off
set verify off
set heading on


column sid heading 'Oracle|SID' format a6
column mode_held heading 'Lock|Type' format a23
column request heading 'Request' format 9999999
column id1 heading 'Lock|Id' format 999999
column name heading 'Object|Name' format a30
column username heading 'ORACLE|User' format a15
column osuser heading 'OS User|Name' format a8
column process heading 'OS|Process' format a8

break on report on name skip 2 on username on osuser

spool &output_file
select lpad(' ',decode(a.request,0,0,3))||a.sid sid,a.id1,
     decode(a.lmode, 0, 'Holding: ','Requests: ')||decode(a.lmode,
      0, 'None',           /* Mon Lock equivalent */
      1, 'Null',           /* N */
      2, 'Row-S (SS)',     /* L */
      3, 'Row-X (SX)',     /* R */
      4, 'Share',          /* S */
      5, 'S/Row-X (SSX)',  /* C */
      6, 'Exclusive',      /* X */
      to_char(a.lmode)) mode_held,
      a.request,c.name, vs.username, vs.osuser, vs.process
from 
	v$session vs,
	sys.obj$ c,
	v$lock b,
	v$lock a
where a.id1 in ( select id1 from v$lock where lmode = 0 )
  and a.sid = b.sid
  and c.obj# = b.id1
  and b.type = 'TM'
  and vs.sid = a.sid
order by a.id1,a.request,b.sid,c.name
/
spool off
start &tool_home/ppcmd
exit
