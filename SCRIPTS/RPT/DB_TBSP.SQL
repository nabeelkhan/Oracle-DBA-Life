REM db_tbsp.sql checked out on 6/12/97 17:05:13 version 1.6
set termout off
REM ---- Var &1 not used

REM ---- Enter the tablespace name or wildcare to match:%
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
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Default Storage Values for Defined Tablespaces with Names like %prefix' skip 2

btitle center 'Report: db_tbsp'

set termout on
prompt
prompt ******** DBA Table Report
prompt
set termout off

set verify off
set feedback off

break on report on tablespace_name skip 1
compute sum of initial_extent on report

column  tablespace_name heading 'Tablespace|Name' format  a30  
column  status          heading 'Status' format  a9  
column  pct_increase    heading '%Inc' format  999  
column  initial_extent  heading 'Init|Extent|(Kbytes)' format  999,999,999,999
column  max_extents     heading 'Max|Extents' format  999,999,999,999
column  min_extents     heading 'Min|Extents' format 999
column  next_extent     heading 'Next|Extent|(Kbytes)' format 999,999,999

spool &output_file
select tablespace_name,initial_extent/1024 initial_extent,next_extent/1024 next_extent,
min_extents,max_extents,pct_increase,status 
from dba_tablespaces
  where tablespace_name like upper('&prefix')
  order by tablespace_name
;
spool off 
start &tool_home/ppcmd
exit
