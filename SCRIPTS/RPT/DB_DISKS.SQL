REM db_disks.sql checked out on 6/12/97 17:05:12 version 1.7
set termout off
REM ---- Enter the Owner or wildcard to match:%
define owner = '&1'

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
center 'Filesystems and Tablespaces for Object Owner Names like &owner and Tablespace Names like &prefix' skip 2

btitle center 'Report: db_disks'

set termout on
prompt
prompt ******** Running DBA Disk Report
prompt
set termout off

set verify off
set feedback off
break on report on disk_nm3 on file_name  skip 1 on file_id on tablespace_name  skip 1

rem compute sum of e_bytes on segment_name
compute sum of e_bytes on tablespace_name
compute sum of e_bytes on file_name
compute sum of e_bytes on report

column  disk_nm1         noprint
rem column  disk_nm3         noprint

column disk_nm3		heading 'Disk'			format  a4
column  e_bytes         heading 'Size| KB'		format  99,999,990
column  file_id         heading 'File| ID'		format  9990
column  file_name       heading 'File Name'		format  a38
column  tablespace_name heading 'Tablespace|Name'	format  a30    
 
column  segment_type    heading 'Segment| Type'		format  a8      
column  segment_name    heading 'Segment| Name'		format  a30
 

spool &output_file
   
select 
  substr(dbaf.file_name,1,((instr(file_name,'/',4) -1))) disk_nm3,
  dbaf.file_name,
  dbaf.file_id,
  dbaf.tablespace_name,
  nvl(dbae.owner,'-')||'.'||nvl(dbae.segment_name,'-') segment_name,
  sum(NVL(dbae.bytes,0))/1024 e_bytes
from dba_extents dbae,
     dba_data_files dbaf
where dbaf.tablespace_name = dbae.tablespace_name (+)
  and dbaf.tablespace_name like upper('&prefix')
  and dbaf.file_id = dbae.file_id (+)
group by substr(dbaf.file_name,1,((instr(file_name,'/',4) -1))) , dbaf.file_name, dbaf.file_id, dbaf.tablespace_name, dbae.owner,
dbae.segment_name
order by 1,dbaf.file_name,dbaf.tablespace_name,dbae.segment_name
;
spool off 
start &tool_home/ppcmd
exit
