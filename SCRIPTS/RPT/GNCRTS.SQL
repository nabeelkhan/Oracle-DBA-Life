REM gncrts.sql checked out on 1/18/97 17:05:14 version 1.6
set termout off
REM ---- Enter the tablespace name or wildcard to match:%
define prefix = '&1'

REM ---- Var '&2' not used

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Var '&6' not used

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

rem Generates the create statements to coalesced by create a dummy table
rem  that uses all free space thus causing the free space to be coalesced.  It
rem  drops the tables which leaves the coalesced block.

set pagesize 0 linesize 80 newpage 0 verify off
column X format a80 word_wrapped

set termout on
prompt
prompt ******** Running DBA Generate Create Compress Extents Tables Script
prompt
set termout off

spool &prefix.creates.sql

select 'create table '||tablespace_name||rownum||
'(dummy char(1))'||
'storage( initial '||sum_bytes||
' next '||sum_bytes||
' minextents 1 maxextents 1)'||
' tablespace '||tablespace_name||';' X
from new_look
where tablespace_name like upper('&prefix')
order by sum_bytes desc /* important */
;

spool off

spool &prefix.drops.sql

select 'drop table '||tablespace_name||rownum||';'
from new_look
where tablespace_name like upper('&prefix');

spool off
prompt 
prompt *************** Files created ***************
prompt ***** Run the following scripts to coallesce free space
prompt ***** &prefix.tables.sql => Creates tables to compress extents
prompt ***** &prefix.drops.sql => Drops the created tables
prompt *****
prompt *********************************************
exit
