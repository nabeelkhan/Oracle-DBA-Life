REM tbspfree.sql checked out on 7/23/97 17:05:17 version 1.9

set termout off

REM ---- Var '&1' not used


REM ---- Enter the tablespace name or wildcard to match:%

define prefix = '&2'


REM ---- Enter the Title for the top of the report:?

define app_name = '&3'


REM ---- Var '&4' not used


REM ---- Var '&5' not used


REM ---- Enter the Output file name for the report:report_name.lst

define output_file='&6'


REM ---- Var '&7' not used


REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'


REM Created by Nabeel Khan in 1998 For his personal 
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Tablespace Free Space and Percent Used for Tablespace Names like &prefix' skip 2

btitle center 'Report: tbspfree'


set termout on

prompt

prompt ******** Running DBA Free Space Report

prompt

set termout off



column  blocks         heading 'DB |Blocks' format  999,999

column  Kb              heading 'Size|(Kb)'  format  99,999,999

column  Kb_free      heading 'Free|(Kb)'  format  99,999,999

column  free            heading '%|Free'  format  999.9

column  file_id         heading 'File| ID' format  9999

column  tablespace_name heading 'Tablespace|Name' format  a25    

column  file_name       heading 'File|Name' format  a36 word_wrapped    

column  status          heading 'Status'    format  a9
 

break on tablespace_name skip 2

break on tablespace_name skip 2

compute sum of Kb on tablespace_name

compute sum of Kb_free on tablespace_name

set termout off

set verify off

set feedback off


spool &output_file


select 
  a.file_name,
  a.tablespace_name,
  a.file_id,
  a.blocks,
  a.bytes/1024 Kb,
  (a.bytes - sum(nvl(b.bytes,0)))/1024 Kb_free,
  100*((a.bytes - sum(nvl(b.bytes,0)))/a.bytes) free,
  status
from dba_data_files a,
     dba_extents b
  where upper(a.tablespace_name) like upper('&prefix')
    and a.file_id = b.file_id (+) 
group by file_name, a.file_id, a.tablespace_name, a.bytes, a.blocks, status
  order by a.tablespace_name,a.file_id
;

spool off 

start &tool_home/ppcmd
exit
