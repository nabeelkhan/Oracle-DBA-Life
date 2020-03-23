REM db_indx.sql checked out on 6/12/97 17:05:16 version 1.4
set termout off
REM ---- Enter the Owner of the table the index is on or wildcard to match:%
define owner = '&1'

REM ---- Enter the  table name the index is on or wildcard to match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var &4 not used

REM ---- Var &5 not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var &7 not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1996 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Index Definitions with Table Owner Names like &owner and Table Names like &prefix' skip 2

btitle center 'Report: db_indx'

set termout on
prompt
prompt ******** Running DBA Index Report
prompt
set termout off
set verify off
set feedback off

break on report on table_name skip 1 on tablespace_name skip 2
compute sum of initial_extent on report
compute sum of initial_extent on tablespace_name


column  tablespace_name heading 'Tablespace|Name' format  a16  
column  table_name      heading 'Table Name'format  a20  
column  index_name      heading 'Index Name'format  a20  
column  cluster_name    heading 'Cluster|Name' format  A10
column  max_extents     heading 'Max |Exts' format  9,990
column  min_extents     heading 'Min |Exts' format  9,990
column  next_extent     heading 'Next|Extent|(KB)' format  9,999,990
column  initial_extent  heading 'Initial|Extent|(KB)' format  999,999,990
column  ini_trans       heading 'Init|Trans' format  9990
column  max_trans       heading 'Max |Trans' format  9990
column  pct_free        heading 'Pct |Free'  format  990
column  pct_increase    heading 'Pct |Incr'  format  990

    
spool &output_file

select 
  TABLE_NAME,
  TABLESPACE_NAME,
  INDEX_NAME,
  INITIAL_EXTENT/1024 initial_extent,
  NEXT_EXTENT/1024 next_extent,
  MIN_EXTENTS,
  MAX_EXTENTS,
  PCT_INCREASE,
  PCT_FREE,
  INI_TRANS,
  MAX_TRANS
from all_indexes
where table_name like upper('&prefix')
  and owner like upper('&owner')
order by table_name, TABLESPACE_NAME, INDEX_NAME
;
spool off 
start &tool_home/ppcmd
exit
