REM lstobjxt.sql checked out on 6/12/97 17:05:18 version 1.4
set termout off
REM ---- Enter the owner of the table/index or wildcard to match:%
define owner = '&1'
 
REM ---- Enter the tablespace name or wildcard to match:%
define tbsp_prefix = '&2'
 
REM ---- Enter Title for the top of the report:?
define app_name = '&3'
 
REM ---- Enter the table name or wildcard to match:%
define prefix = '&4'

REM ---- Var &5 not used
 
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
center 'Objects whose next extent exceeds free space in Tablespace' skip 1 -
center 'for Table names like &prefix and Owner names like &owner in Tablespace name like &tbsp_prefix' skip 2

btitle center 'Report: lstobjxt'

set termout on
prompt
prompt ******** Objects with next extents 
prompt   larger than remaining free space
prompt      for &app_name 
prompt      for owner like &owner
prompt      and object name like &prefix
prompt      and tablespace name like &tbsp_prefix
prompt
set termout off

set feedback off
set verify off
set heading on


column owner heading 'Owner' format a20
column tablespace_name heading 'Tablespace|Name' format a20
column table_name heading 'Table Name' format a30
column index_name heading 'Index' format a30
column next_extent heading 'Next|Extent|(Kb)' format 999,999,990
column ord_col noprint

break on report on owner skip 2 on tablespace_name on table_name skip 1



spool &output_file
select /*+ RULE */
owner, tablespace_name, table_name, 1 ord_col,'' index_name, next_extent/1024 next_extent
from all_tables at
where owner like upper('&owner')
  and table_name like upper('&prefix')
  and tablespace_name like upper('&tbsp_prefix')
  and next_extent > (select max(a.bytes) 
		     from dba_free_space a
		     where a.tablespace_name = at.tablespace_name
		    )
union
select /*+ RULE */
owner, tablespace_name, table_name, 2 ord_col, index_name, next_extent/1024 next_extent
from all_indexes ai
where owner like upper('&owner')
  and table_name like upper('&prefix')
  and tablespace_name like upper('&tbsp_prefix')
  and next_extent > ( select max(a.bytes)
		      from dba_free_space a
		      where a.tablespace_name = ai.tablespace_name
		     )
order by 1,2,3,4
/
spool off
start &tool_home/ppcmd
exit
