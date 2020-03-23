REM lsttbl.sql checked out on 6/12/97 17:05:16 version 1.6
set termout off
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the table name or wildcard to Match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter Switch to look at tables only 'Y' or tables and views 'N':y
define tables_only = '&4'

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
center 'Tables and their descriptions for Owners like &owner and Names like &prefix'  skip 2

btitle center 'Report: lsttbl'

set feedback off
set verify off
set heading on

set termout on
prompt
prompt Generating description of all tables 
prompt for owner = '&owner' and table name like '&prefix'
prompt 
set termout off

column tablename heading Table format a30
column table_type heading 'Table|Type' format a5
column comments WORD_WRAPPED heading Description format a85
break on tablename skip 1

spool &output_file
select table_name tablename,table_type,comments
from all_tab_comments alcom
where alcom.owner like upper('&owner')
 and alcom.table_name like upper('&prefix')
 and table_type like decode(upper('&tables_only'),'Y','TABLE','%')
order by alcom.table_name;
spool off
start &tool_home/ppcmd
exit
