REM lsttblnk.sql checked out on 6/12/97 17:05:16 version 1.8
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
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Tables with Names like &prefix and owner like &owner without Primary keys' skip 2

btitle center 'Report: lsttblnk'

set feedback off
set verify off
set heading on

set termout on
prompt
prompt ******** Running DBA List Tables without Primary Keys
prompt 
set termout off

column tablename heading Table format a30
column owner heading 'Table|Owner' format a20
column comments heading Description format a74 word_wrapped
break on owner skip 2

spool &output_file
select alcom.owner,alcom.table_name tablename, alcom.comments
from all_tab_comments alcom
where alcom.owner like upper('&owner')
 and alcom.table_name like upper('&prefix')
 and alcom.table_type = 'TABLE'
 and not exists (select null from all_constraints dc 
				  where  dc.table_name = alcom.table_name and
				         dc.constraint_type = 'P')
union
select alcom.owner, alcom.table_name tablename, alcom.comments
from all_tab_comments alcom
where alcom.owner like upper('&owner')
 and alcom.table_name like upper('&prefix')
 and alcom.table_type = 'TABLE'
 and not exists (select null from all_indexes dc 
				  where dc.table_name = alcom.table_name
				    and dc.table_owner = alcom.owner
				    and dc.uniqueness = 'UNIQUE')
order by 1,2;
spool off
start &tool_home/ppcmd
exit
