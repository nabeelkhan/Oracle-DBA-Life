REM db_syns.sql checked out on 6/12/97 17:05:13 version 1.7
set termout off
REM ---- Enter the Owner of the synonyms or wildcard  to match:%
define owner = '&1'

REM ---- Enter the table/object owner or wildcard to match:%
define tab_owner = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter the table/object name or wildcard to match:%
define prefix = '&4'

REM ---- Enter the synonym name or wildcard to match:%
define synonym='&5'

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file = '&6'

REM ---- Var &7 not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Synonyms defined owned by &owner with names like &synonym and' skip 1 -
center 'for tables owned by &tab_owner and names like &prefix' skip 2

btitle center 'Report: db_syns'

column owner heading 'Owner' format a20
column synonym_name heading 'Synonym Name' format a30
column table_owner heading 'Table Owner' format a20
column table_name heading 'Table Name' format a30
column db_link heading 'DB Name' format a20


set feedback off
set verify off
set heading off

set termout on
prompt
prompt ******** Running DBA Synonyms Report
prompt
set termout off

set headin on
set feedback off

break on report on owner skip 1 on table_owner skip 1

spool &output_file
select
  owner,
  synonym_name,
  table_owner,
  table_name,
  db_link
from dba_synonyms
where owner like upper('&owner')
  and synonym_name like upper('&synonym')
  and table_name like upper('&prefix')
  and table_owner like upper('&tab_owner')
order by 1,2,3,4
/
spool off
start &tool_home/ppcmd
exit
