REM lstconst.sql checked out on 8/27/97 17:05:15 version 1.9
set termout off
REM ---- Enter the Foreign Key Table Owner or wildcard to match:%
define owner = '&1'

REM ---- Enter the Foreign Key Table name or wildcard to match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Enter the Primary Key Table owner or wildcard to match:%
define ref_owner='&4'

REM ---- Enter the Primary Key Table name or wildcard to match:%
define ref_prefix='&5'

REM ---- Enter the Output file name for the report:$report_name.lst
define output_file='&6'

REM ---- Var &7 not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1990 
rem Copyright The DataBase Group, Inc.
rem 1996, 1997
rem
start &tool_home/lformat
start &tool_home/rptvars
ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Referential Constraints for Foreign table owner like &owner and Foreign Key table names like &prefix' skip 1 -
center 'and Primary Key table owner like &ref_owner and Primary Key table names like &ref_prefix' skip 2

btitle center 'Report: lstconst'

set feedback off
set verify off
set heading on

set termout on
prompt
prompt ******** Running DBA List Referential Constraints Report
prompt
prompt for Foreign Key Table Owner like &owner
prompt and Foreign Key Table Names like &prefix
prompt
prompt and Primary Key Table Owner like &ref_owner
prompt and Primary Key Table Names like &ref_prefix
prompt
set termout off

column table_name heading Table format a30
column constraint_name heading 'Name of |Constraint' format a30
column column_name heading 'Name of Referenced|Column' format a30
column ref_table_name heading 'Referenced |Table' format a30
column constraint_name heading 'Name of Referenced |Unique or Primary Key' format a30
break on table_name skip 1 on constraint_name

spool &output_file

select
cd.table_name,cd.constraint_name, cc.table_name ref_table_name, cc.constraint_name, cc.column_name
from 
	all_cons_columns cc,
	all_constraints cd
where cd.table_name like upper('&prefix')
  and cd.owner like upper('&owner')
  and cc.table_name like upper('&ref_prefix')
  and cc.owner like upper('&ref_owner')
  and cd.r_constraint_name = cc.constraint_name
  and cd.r_owner like upper('&ref_owner')
  and cd.constraint_type != 'C'
order by cd.table_name,3,cc.column_name;

spool off
start &tool_home/lpcmd
exit
