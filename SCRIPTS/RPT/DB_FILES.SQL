REM db_files.sql checked out on 6/12/97 17:05:13 version 1.6
set termout off
REM ---- Var '&1' not used

REM ---- Enter the tablespace name or wildcard to match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter the name of the Output file for the report:$report_name.lst
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
center 'Files assigned to Tablespaces with Names like &prefix' skip 2

btitle center 'Report: db_files'

set termout on
prompt
prompt ******** Running DBA Files Report
prompt
set termout off

set verify off
set feedback off

compute sum of bytes on report
compute sum of bytes on tablespace_name
compute sum of blocks on report
compute sum of blocks on tablespace_name

break on report on tablespace_name skip 2


column  blocks          heading 'Blocks'           format  99,999,999
column  bytes           heading 'Bytes'            format  999,999,999,999
column  file_id         heading 'File| ID'         format  99999
column  status          heading 'File|Status'      format  a10
column  file_name       heading 'File Name'        format  a40 word_wrapped
column  tablespace_name heading 'Tablespace|Name' format  a30    
 
spool &output_file
   
select 
  tablespace_name,
  file_id,
  file_name,
  blocks,
  bytes,
  status
from dba_data_files
where tablespace_name like upper('&prefix')
order by tablespace_name,file_id 
;
spool off 
start &tool_home/ppcmd
exit
