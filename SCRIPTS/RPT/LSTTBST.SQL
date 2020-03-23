REM lsttbst.sql checked out on 6/12/97 17:05:16 version 1.6
set termout off
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the table name or wildcard string to match:%
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
center 'Tables with Names like &prefix and Owner like &owner Column Statistics Values' skip 2

btitle center 'Report: lsttbst'

set termout on
prompt
prompt ******** Running DBA List Table and Column Statistics Report
prompt
set termout off

column  table_name      heading 'Table Name'             format  a19
column  column_name     heading 'Column Name'            format  a25
column  data_type       heading 'Type'                   format  a14
column  num_distinct    heading 'Number|Distinct'        format  99,999,990
column  low_value       heading 'Low Value'              format  a20
column  high_value      heading 'High Value'             format  a20
column  density         heading 'Density'                format  .90

set feedback off
set verify off
set termout off
set heading on
set arraysize 5

break on owner skip 2 on table_name skip 1

spool &output_file

select ac.table_name, ac.column_name, ac.data_type, ac.num_distinct,
replace(substr(decode(ac.data_type,'NUMBER',dump(ac.low_value,1),dump(ac.low_value,17)),15),',','') low_value,
replace(substr(decode(ac.data_type,'NUMBER',dump(ac.high_value,1),dump(ac.high_value,17)),15),',','') high_value,
ac.density 
from all_tab_columns ac,
     all_tables at
where ac.owner like upper('&1') 
  and at.owner = ac.owner
  and ac.table_name like upper('&2')
  and at.table_name = ac.table_name
order by ac.owner, ac.table_name, ac.column_name
/
spool off
start &tool_home/ppcmd
exit
