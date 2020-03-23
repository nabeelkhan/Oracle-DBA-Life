REM lstcache.sql checked out on 12/14/97 17:05:18 version 1.6
set termout off
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the table name or wildcard to Match:%
define prefix = '&2'

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
rem Created by Marc E. Marchioli
rem Copyright 1996 The DataBase Group, Inc.
rem
start &tool_home/pformat
start &tool_home/rptvars


ttitle left jobdate jobtime center 'Objects in the Library Cache and Executions/Loads' right 'Page: ' format 999 sql.pno skip 1 -
center 'For Owner like '&owner' and Object Names like '&prefix'' skip 2

btitle center 'Report: lstcache'

set feedback off
set verify off
set heading on

set termout on
prompt
prompt ******** Running DBA List Packages Not Cached Report
prompt for owner like:                   &owner
prompt and procedure/function/trigger name like: &prefix
prompt 
prompt WARNING! Requires access to V$ tables owned by 'SYS'
prompt 
set termout off

column owner heading 'Owner' format a12
column name heading 'Name' format a40
column type heading 'Type' format a10
column sharable_mem heading 'Sharable|Memory|(bytes)' format 999,990
column executions heading 'Executions' format 99,999,990
column loads heading 'Times|Loaded' format 999,990
column kept heading 'Pinned|(?)' format a6

spool &output_file
 
select owner, name, initcap(type) type, sharable_mem, executions, loads, initcap(kept) kept
from v$db_object_cache
where type <> 'NOT LOADED'
and type in ('PACKAGE','FUNCTION','PROCEDURE','SEQUENCE','TRIGGER')
and owner like upper('&owner')
and name like upper('&prefix')
order by executions desc, sharable_mem desc, loads desc
/
spool off
start &tool_home/ppcmd
exit
