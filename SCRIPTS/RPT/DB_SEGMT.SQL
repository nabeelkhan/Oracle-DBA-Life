REM db_segmt.sql checked out on 6/12/97 17:05:13 version 1.7
set termout off
REM ---- Enter the Owner of the segments (Tables, Indexes, etc) or wildcard to match:%
define owner = '&1'

REM ---- Enter the name of the tablespace or wildcard to match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&4' not used

REM ---- Var &5 not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var &7 not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

set verify off 
set feedback off

rem
rem Created by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Segments allocated for Object Names like &prefix and Owner Names like &owner' skip 2

btitle center 'Report: db_segmt'

set termout on
prompt
prompt ******** Running DBA Segments Report
prompt
set termout off

break on report on tablespace_name skip 2
compute sum of bytes  on report
compute sum of bytes  on tablespace_name
compute sum of blocks on report
compute sum of blocks on tablespace_name

column  owner           heading Owner	format  a12 
column  kbytes          heading Kb   format  999,999,999
column  blocks          heading 'Actual|Blocks' format  999,999,999
column  segment_type    heading 'Segment |Type' format  a8   
column  segment_name    heading 'Segment |Name' format  a30  
column  tablespace_name heading 'Tablspace|Name' format  a15  
column  max_extents     heading 'Max |Exts'     format  999
column  header_block    heading 'Hdr |Block'     format  999999
column  header_file     heading 'Hdr |File'     format  99
column  extents         heading 'Actual|Extnts' format  999

spool &output_file

select 
  TABLESPACE_NAME,
  SEGMENT_TYPE,
  SEGMENT_NAME,
  EXTENTS,
  MAX_EXTENTS,
  BLOCKS,
  BYTES/1024 kbytes,
  HEADER_BLOCK,
  HEADER_FILE,
  OWNER
from dba_segments
where tablespace_name like upper('&prefix')
  and owner like upper('&owner')
order by TABLESPACE_NAME,SEGMENT_TYPE,SEGMENT_NAME
;
spool off 
start &tool_home/ppcmd
exit
