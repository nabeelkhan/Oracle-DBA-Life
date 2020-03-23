REM obj_exts.sql checked out on 10/18/97 17:05:16 version 1.8
set termout off
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the tablespace name or wildcard to match:%
define tbsp_prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter the table name or wildcard to match:%
define prefix = '&4'

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
center 'Extents allocated to Objects for Object names like &prefix and Owner names like &owner in Tablespace name like &tbsp_prefix' skip 2

btitle center 'Report: obj_exts'

set termout on
prompt
prompt ******** Running  DBA Extents Report
prompt for Segment Owner like &owner
prompt and Tablespace name like &tbsp_prefix
prompt and Segment/Table/Index Name like &prefix
prompt
set termout off

set verify off
set feedback off

break on report on tablespace_name skip 2 on segment_type on owner on segment_name skip 1

compute sum of kbytes on report
compute sum of kbytes on tablespace_name
compute sum of kbytes on segment_name

column  tablespace_name heading 'Tablespace|Name'        format  a19    
column  segment_type    heading 'SEGMENT| TYPE'          format  a9      
column  owner           heading OWNER                    format  a12 
column  segment_name    heading 'SEGMENT| NAME'          format  a30
column  file_id         heading 'File| ID'               format  99999
column  extent_id       heading 'Extent|ID'              format  99999
column  blocks          heading 'Number| of Blocks'      format  999,999
column  kbytes          heading 'Kbytes'                 format  999,999,999
column  block_id        heading 'Extent|Starts|in BLK#'  format  999,999

spool &output_file
select 
  TABLESPACE_NAME,
  SEGMENT_TYPE,
  OWNER,
  SEGMENT_NAME,
  FILE_ID,
  EXTENT_ID,
  BLOCKS,
  BYTES/1024 kbytes,
  BLOCK_ID
from dba_extents dbe
  where tablespace_name like upper('&tbsp_prefix')
    and dbe.owner like upper('&owner')
    and exists (select null 
		from all_tables ats 
		where ats.owner like upper('&owner') 
		  and ats.table_name like upper('&prefix') 
		  and ats.owner = dbe.owner
		  and ats.table_name = dbe.segment_name
		)
union
select 
  TABLESPACE_NAME,
  SEGMENT_TYPE,
  OWNER,
  SEGMENT_NAME,
  FILE_ID,
  EXTENT_ID,
  BLOCKS,
  BYTES/1024 kbytes,
  BLOCK_ID
from dba_extents dbe
  where tablespace_name like upper('&tbsp_prefix')
    and dbe.owner like upper('&owner')
    and exists ( select null 
		from all_indexes ats2 
		where ats2.table_owner like upper('&owner') 
		  and ats2.table_name like upper('&prefix')
		  and ats2.index_name = dbe.segment_name
		  and ats2.owner = dbe.owner
		  )
union
select 
  TABLESPACE_NAME,
  SEGMENT_TYPE,
  OWNER,
  SEGMENT_NAME,
  FILE_ID,
  EXTENT_ID,
  BLOCKS,
  BYTES/1024 kbytes,
  BLOCK_ID
from dba_extents dbe
  where dbe.tablespace_name like upper('&tbsp_prefix')
    and dbe.owner like upper('&owner')
    and dbe.segment_name like upper('&prefix')
order by 1,2,3,4,6
;
spool off 
start &tool_home/ppcmd
exit
