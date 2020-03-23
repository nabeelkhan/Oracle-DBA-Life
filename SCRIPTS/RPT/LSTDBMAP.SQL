REM lstdbmap.sql checked out on 8/16/97 17:05:20 version 1.2
set termout off
REM ---- Enter the tablespace name or wildcard to match:%
define tablespace = '&1'

REM ---- Var '&2' not used

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&3' not used

REM ---- Var '&5' not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem Copyright The DataBase Group, Inc. 1997 
REM  Created by Mburns  8/15/95  Original

set feedback off
set verify off
set heading on

set termout on
prompt
prompt ******** Running DBA Map Database Blocks
prompt for tablespace name like: &tablespace
prompt
set termout off



col tablespace format       a15 justify c trunc heading 'TSpace'
col file_id    format       990 justify c       heading 'File'
col block_id   format 9,999,990 justify c       heading 'Starts in|Block Id'
col blocks     format 9,999,990 justify c       heading 'Size|(DB Blocks)'
col segment    format       a50 justify c trunc heading 'Segment'
col MBytes     format 9,999.00  justify c       heading 'Size|(Mb)'

break on tablespace skip 1 on file_id 

start &tool_home/pformat
start &tool_home/rptvars

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Map of Segments and Free Space for tablespace name like ''&tablespace'' for DB blocksize of &blocksize bytes' skip 2

btitle center 'Report: lstdbmap'



spool &output_file

select
  tablespace_name              tablespace,
  file_id,
  block_id,
  blocks,
  (blocks * &blocksize)/1048576 MBytes,
  owner||'.'||segment_name     segment
from
  dba_extents
where tablespace_name like upper('&tablespace')
union
select
  tablespace_name  tablespace,
  file_id,
  block_id,
  blocks,
  (blocks * &blocksize)/1048576 MBytes,
  '<free>'
from
  dba_free_space
where tablespace_name like upper('&tablespace')
order by
  1,2,3
/

spool off
start &tool_home/ppcmd
exit
