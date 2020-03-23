REM lstindst.sql checked out on 6/12/97 17:05:15 version 1.6
set termout off
REM ---- Enter the Owner of the tables to be scanned:%
define owner = '&1'

REM ---- Enter the object name or wildcard to Match:%
define prefix = '&2'

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
center 'Index Statistics with Owner Names like &owner and Names like &prefix' skip 2

btitle center 'Report: lstindst'

set termout on
prompt
prompt ******** Running DBA List Index Statistics Report
prompt
set termout off

column  table_name      heading 'Table Name'             format  a30
column  index_name      heading 'Index Name'             format  a30
column  blevel          heading 'B Level'                format  999,990
column  leaf_blocks     heading 'Leaf|Blocks'            format  999,990
column  DISTINCT_KEYS      heading 'Distinct|Keys'       format  99,999,990
column  AVG_LEAF_BLOCKS_PER_KEY  heading 'Leafs|per key' format  999,990
column  AVG_DATA_BLOCKS_PER_KEY  heading 'Data|per key'  format  999,990
column  CLUSTERING_FACTOR  heading 'Clustering|Factor'   format  99,999,990

set feedback off
set verify off
set termout off
set heading on
set arraysize 5


spool &output_file

select table_name, index_name, blevel,
leaf_blocks, distinct_keys, 
avg_leaf_blocks_per_key,avg_data_blocks_per_key , clustering_factor
from all_indexes 
where owner like upper('&1') 
  and table_name like upper('&2')
order by owner, table_name, index_name
/
spool off
start &tool_home/ppcmd
exit
