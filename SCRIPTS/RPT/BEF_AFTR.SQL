REM bef_aftr.sql checked out on 6/12/97 17:05:11 version 1.7
set termout off

REM ---- Var '&1' not used

REM ---- Enter the tablespace name or wildcard string to match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter the Output file for the report:$report_name.lst
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
center 'Before and After Coallescing Free Space Changes Report for Tablespace Names like &prefix' skip 1

btitle center 'Report: bef_aftr'

break on starting_file_id skip 1
column tablespace_name heading 'Tablespace Name' format a30
column new_length format 9999999
column num_fragments format 99999999
set termout on
prompt
prompt ***** Running Compress Extents Before_After Report
prompt
set termout off

set verify off
set feedback off
spool &output_file

select tablespace_name,starting_file_id, starting_block_id,
	sum(blocks) new_length,
	count(blocks) num_fragments,
	max(blocks) current_top
from contig_space
where tablespace_name like upper('&prefix')
group by tablespace_name, starting_file_id, starting_block_id
having count(*) > 1
order by 1,2,3;

ttitle center 'Old LFI rating for &app_name &prefix' skip 1
column lfi format 999.999
select tablespace_name,sqrt(max(blocks)/sum(blocks))*
	(100/sqrt(sqrt(count(blocks)))) lfi
from dba_free_space
where tablespace_name like upper('&prefix')
group  by tablespace_name;

ttitle center 'New LFI rating for &app_name  &prefix' skip 1
colum new_lfi format 999.999
select tablespace_name,sqrt(max(sum_blocks)/sum(sum_blocks))*
	(100/sqrt(sqrt(count(sum_blocks)))) lfi
from new_look
where tablespace_name like upper('&prefix')
group by tablespace_name;

spool off
start &tool_home/ppcmd
exit
