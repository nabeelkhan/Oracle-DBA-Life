REM fragindx.sql checked out on 7/24/97 17:05:14 version 1.8
set termout off
REM ---- Enter the tablespace name or wildcard to match:%
define prefix = '&1'

REM ---- Enter the order by preference (1=> by tablespace name, 2=> frag index):2
define order_by = '&2'

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
rem scripted by Marc E. Marchioli
rem in 1993 
rem Copyright 1996, 1997 by The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars

column order_by_prompt new_value order_by_prompt noprint
 
select decode('&order_by', '1', 'tablespace name', '2', 'fragmentation index', 'tablespace name') order_by_prompt
from dual;

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Loney Fragementation Index for Tablespaces with Names like &prefix ordered by &order_by_prompt' skip 1 -
center 'Values larger than 20 are preferable (e.g. the lower the value the more fragmentation) ' skip 2

btitle center 'Report: fragindx'

column lfi format 999.99

set verify off
set feedback off
set termout on
prompt
prompt ***** DBA List Fragmentation Index
prompt ***** Loney Fragmentation Index (LFI)
prompt ***** Values larger than 20 may be tolerable
prompt ***** ordered by &order_by_prompt

set termout off
spool &output_file
select tablespace_name,
       sqrt(max(blocks)/sum(blocks))*
	 (100/sqrt(sqrt(count(blocks)))) lfi
from dba_free_space
where tablespace_name like upper('&prefix')
group by tablespace_name
order by &order_by
/
spool off
start &tool_home/ppcmd
exit
