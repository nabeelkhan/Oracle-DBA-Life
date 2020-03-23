REM lstfilst.sql checked out on 12/15/97 17:05:21 version 1.2
set termout off
REM ---- Enter the tablespace name  or wildcard to match:%
define tbsp = '&1'
 
REM ---- Enter the file name or wildcard to match:%
define file_name = '&2'
 
REM ---- Enter Title for the top of the report:?
define app_name = '&3'
 
REM ---- Enter order by preference (Physical 1=> reads, 2=> writes, 3=> blocks read, 4=> blocks written) (Time 5=> read, 6=> write) (7=> tablespace name) (8=> file name):7
define order_by_pref = '&4'
 
REM ---- Var &5 Not used
 
REM ---- Enter the Output file name for the report:$report_name.sql
define output_file='&6'
 
REM ---- Var &7 not used
 
REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem Copyright 1997 The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars

column order_by_txt new_value order_by_txt noprint
column break_txt new_value break_txt noprint
column order_by_prompt new_value order_by_prompt noprint

select decode('&order_by_pref', '1', 'phyrds desc', '2', 'phywrts desc', '3', 'phyblkrd', '4', 'phyblkwrt desc', 
																'5', 'readtim desc', '6', 'writetim desc', '7', 'tablespace_name, file_name', 
																'8', 'file_name', 'tablespace_name, file_name') order_by_txt,
decode('&order_by_pref', '1', 'physical reads descending', '2', 'physical writes descending', '3', 'physical blocks read', 
												 '4', 'physical blocks written descending', '5', 'read time descending ', '6', 'write time descending', 
												 '7', 'tablespace_name, file_name', '8', 'file_name', 'tablespace_name') order_by_prompt,
decode('&order_by_pref', '1', 'report', '2', 'report', '3', 'report', '4', 'report', '5', 'report', '6', 'report', 
												 '7', 'report on tablespace_name skip 1', '8', 'report', 'report on tablespace_name skip 1') break_txt
from dual;
set termout on
prompt
prompt ******** Reporting DB File Statistics
prompt      for &app_name 
prompt      for Tablespace Name like &tbsp
prompt      and File name like &file_name
prompt      ordered by &order_by_prompt
prompt

set termout off
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Database File I/O Statistics for tablespace name like &tbsp and file name like &file_name' skip 1 -
center 'ordered by &order_by_prompt' skip 1 -
center 'blocksize is &blocksize bytes' skip 2

btitle center 'Report: lstfilst'

set feedback off
set verify off
set heading on


column file_name  heading 'File Name' format a28
column tablespace_name heading 'Tablespace|Name' format a20
column phyrds heading 'Physical|Reads|(#)' format 999,999,990
column phywrts heading 'Physical|Writes|(#)' format 999,999,990
column phyblkrd heading 'Physical|Blocks|Read' format 999,999,990
column phyblkwrt heading 'Physical|Blocks|Written' format 999,999,990
column readtim heading 'Avg.|Read|Time|(ms)' format 9,999.90
column writetim heading 'Avg.|Write|Time|(ms)' format 9,999.90


break on &break_txt

spool &output_file
select dbf.tablespace_name, file_name, phyrds, phywrts, phyblkrd, phyblkwrt, decode(phyrds, 0, 0, 10*readtim/phyrds) readtim, 
decode(phywrts, 0, 0, 10*writetim/phywrts) writetim
from
     v$filestat vf,
     dba_data_files dbf
where dbf.file_id = vf.file#
and file_name like '&file_name'
and tablespace_name like '&tbsp'
order by &order_by_txt
/
spool off
start &tool_home/ppcmd
exit
