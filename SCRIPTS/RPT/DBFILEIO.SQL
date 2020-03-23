REM dbfileio.sql checked out on 12/30/97 14:46:15 version 1.4
set termout off
REM ---- Enter the file name or wildcard to match:%
define filename = '&1'

REM ---- Enter order by preference(1=> Path, file; 2=> physical reads desc, writes desc; 3=> physical writes desc, reads desc):1
define order_pref = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&3' not used

REM ---- Var '&5' not used

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var '&7' not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem  Copyright The DataBase Group, Inc. 1997
REM  Originally created by Mburns  8/15/95
REM  modified by Marc Marchioli 8/15/97
rem

column order_txt new_value order_txt noprint
column order_prompt new_value order_prompt noprint

select decode('&order_pref', '1', '1,2', 
			     '2', '5 desc, 6 desc', 
			     '3', '6 desc, 5 desc', 
			'1,2') order_txt,
       decode('&order_pref', '1', 'Path, File Name', 
			     '2', 'Physical Reads desc, Physical Writes desc', 
			     '3', 'Physical Writes desc, Physical Reads desc', 
		        'Path, File Name') order_prompt
from dual;

set feedback off
set verify off
set heading on

set termout on
prompt ******** Warning: Must be run as SYS
prompt
prompt ******** Running DBA Database File I/O
prompt for file names like: &filename
prompt and ordered by &order_prompt
prompt
set termout off

start &tool_home/pformat
start &tool_home/rptvars

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Location and path with physical I/O of all files with names like ''&filename'' and DB Block size of &blocksize bytes' skip 1 -
center 'ordered by &order_prompt' skip 2

btitle center 'Report: dbfileio'



col path  format a20     heading 'Path'
col fname format a15     heading 'File Name'
col fsize format 99,999,999b    heading 'Size|(Mb)'
col pr    format 999,999,999,999b heading 'Physical Reads|DB Blocks'
col pw    format 999,999,999,999b heading 'Physical Writes|DB Blocks'
col cdate format a17 heading 'Creation Date'
col tname format a20     heading 'Tablespace Name'



break on path skip 1

spool &output_file

select substr(name,1,instr(name, '/', -1)-1 ) path,
       substr(name,instr(name, '/', -1)+1 )  fname,
       tablespace_name tname,
       df.bytes/1048576  fsize,
       phyrds pr,
       phywrts pw ,
       fecrc_tim cdate
  from v$datafile df, v$filestat fs , x$kccfe x,
       dba_data_files dt
 where df.file# = fs.file#
   and df.file# = x.indx + 1
   and df.file# = dt.file_id
   and name like '&filename'
UNION
select substr(name,1,instr(name, '/', -1)-1 ) path,
       substr(name,instr(name, '/', -1)+1 ) fname,
       NULL,
       0 fsize,
       0 pr,
       0 pw ,
       null
  from v$controlfile
  where name like '&filename'
UNION
select substr(lgf.member,1,instr(lgf.member,'/', -1)-1) path,
       substr(lgf.member,instr(lgf.member, '/', -1)+1 ) fname,
       'Redo Log',
       lg.bytes/1048576 fsize,
       0 pr,
       0 pw ,
       null
  from v$logfile lgf, v$log lg
 where lgf.group# = lg.group#
   and lgf.member like '&filename'
order by &order_txt
/
spool off
start &tool_home/ppcmd
exit

