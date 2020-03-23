REM lstrbkst.sql checked out on 6/12/97 17:05:19 version 1.3
set termout off
REM ---- Enter the rollback segment name or wildcard to match:%
define seg_name = '&1'
 
REM ---- Var '&2' not used
 
REM ---- Enter Title for the top of the report:?
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
rem in 1997 For his personal use
rem Copyright 1997 The DataBase Group, Inc.
rem
start &tool_home/lformat
start &tool_home/rptvars
set termout on
prompt
prompt ******** DBA list Rollback Statistics Report
prompt      for &app_name 
prompt      and rollback segment name  like &seg_name
prompt
set termout off
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Rollback Segment Statistics for segment name  like &seg_name' skip 2

btitle center 'Report: lstrbkst'

set feedback off
set verify off
set heading on


column name heading 'Rollback|Segment Name' format a15
column extents heading '# of|Extents' format 999
column rssize heading 'Size|(Kb)' format 9,999,990
column writes heading 'Kb|Written' format 999,999,990
column xacts heading '# Act.|Trans' format 9,990
column gets heading '# of|header gets' format 99,999,990
column waits heading '# of|header waits' format 999,990
column optsize heading 'Optimum|Size|(Kb)' format 999,990
column hwmsize heading 'High Water|Mark' format 99,999,990
column shrinks heading '# of|Shrinks' format 9,990
column wraps heading '# of|Wraps' format 9,990
column extends heading '# of|Extends' format 9,990
column aveshrink heading 'Average|Shrinks' format 999,999,990
column aveactive heading 'Average|Active' format 999,999,990
column status heading 'Status' format a7 word_wrapped

spool &output_file
select name, extents, rssize/1024 rssize, writes/1024 writes, xacts, gets, waits, optsize/1024 optsize, hwmsize/1024 hwmsize, 
		   shrinks, wraps, extends, aveshrink, aveactive, status
from v$rollname vr,
		 v$rollstat vrs
where vr.name like upper('&seg_name')
	and vr.usn = vrs.usn
order by name
/
spool off
start &tool_home/lpcmd
exit
