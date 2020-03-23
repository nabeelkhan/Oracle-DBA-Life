REM db_rbk.sql checked out on 10/18/97 17:05:18 version 1.7
set termout off
REM ---- Enter the Owner of the rollback segments or wildcard to match:%
define owner = '&1'

REM ---- Enter the  rollback segment name or wildcard to match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter the tablespace name or wildcard that the rollback segments are in:%
define tbs_name = '&4'

REM ---- Var &5 not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var &7 not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Rollback Segments with Owner Names like &owner and Segment Names like &prefix' skip 2

btitle center 'Report: db_rbk'

set termout on
prompt
prompt ******** Running DBA Rollback Segment Report
prompt
set termout off
set verify off
set feedback off

break on report on tablespace_name skip 2


column  tablespace_name heading 'Tablespace|Name' format  a19  
column  segment_name   heading 'Segment Name'format  a25  
column  max_extents     heading 'Max |Exts' format  9,990
column  min_extents     heading 'Min |Exts' format  9,990
column  next_extent     heading 'Next|Extent|(KBytes)'    format  9,999,990
column  initial_extent  heading 'Initial|Extent|(KBytes)' format  9,999,990
column  instance_num    heading 'Instance' format  a2
column  max_trans       heading 'Max |Trans' format  99990
column  pct_increase    heading 'Pct |Incr'  format  990
column  optsize		heading 'Optimal|Size|(Kbytes)' format 999,999,990
column  status        heading 'Status'  format  a16

    
spool &output_file

select 
  tablespace_name,
  segment_NAME,
  INITIAL_EXTENT/1024 initial_extent,
  NEXT_EXTENT/1024 next_extent,
  optsize/1024 optsize,
  MIN_EXTENTS,
  MAX_EXTENTS,
  PCT_INCREASE,
  instance_num,
  rs.status
from dba_rollback_segs rs,
     sys.v_$rollstat rstat
where segment_name like upper('&prefix')
  and tablespace_name like upper('&tbs_name')
  and owner like upper('&owner')
  and rs.segment_id = rstat.usn (+)
order by TABLESPACE_NAME,segment_name
;
spool off 
start &tool_home/ppcmd
exit
