REM mapper.sql checked out on 6/12/97 17:05:16 version 1.9
set termout off
REM ---- Enter the tablespace_name or wildcard to match:%
define prefix = '&1'

REM ---- Var '&2' not used

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
rem Original author unknown,
rem typed in by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Mapping of tables to tablespace and freespace for Tablespace Names like &prefix' skip 2

btitle center 'Report: mapper'

set termout on
prompt
prompt ******** Running DBA Map Freespace Report
prompt
set termout off

column owner heading 'Owner' format a20
column object heading 'Object'
column file_name heading 'File Name' format a34
column block_id heading 'Block ID'
column blocks heading 'Number of|Oracle Blocks' format 999,999,999
column bytes heading 'Size|(Kb)' format 9,999,990
break on file_name on owner on report

set verify off
set feedback off

spool &output_file

select '*->free space' owner, '       ' object, df.file_name, 
block_id, fs.blocks, (fs.blocks*&blocksize)/1024 bytes
from dba_free_space fs,
     dba_data_files df
where fs.tablespace_name like upper('&prefix')
  and fs.file_id = df.file_id
union
select owner,
       substr(segment_name,1,30),
       df.file_name, block_id, e.blocks, (e.blocks*&blocksize)/1024 bytes
from dba_extents e,
     dba_data_files df
where e.tablespace_name like upper('&prefix')
  and e.file_id = df.file_id
order by 3,4;

column  blocks          heading 'DB |Blocks' format  999,999
column  Kb              heading 'Size|(Kb)'  format  99,999,999
column  Kb_free         heading 'Free|(Kb)'  format  99,999,999
column  free            heading '%|Free'  format  999.9
column  file_id         heading 'File| ID' format  9999
column  tablespace_name heading 'Tablspace|Name' format  a25
column  file_name       heading 'File|Name' format  a36 word_wrapped
column  status          heading 'Status'    format  a9

break on tablespace_name skip 2
break on tablespace_name skip 2
compute sum of Kb on tablespace_name
compute sum of Kb_free on tablespace_name

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
