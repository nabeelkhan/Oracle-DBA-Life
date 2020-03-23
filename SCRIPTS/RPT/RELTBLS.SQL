REM reltbls.sql checked out on 6/12/97 17:05:16 version 1.7
set termout off
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the table name or wildcard to match:%
define prefix = '&2'

REM ---- Enter the Title for the top of the report:?
define app_name = '&3'

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter the Output file for name the report:$report_name.lst
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


column   columnname2 heading  'Related|Column'
column   tablename2  heading  'Child or|Related table'
column   columnname1  heading  'Primary Key|Column'
column   tablename1  heading  'Reference|Table'
column buff fold_after 1
break on tablename1 skip 2 on columnname1 skip 1

set termout on
set verify off
set heading off
prompt
prompt ******** Running DBA List Possible Related Tables Report
prompt for owner like:      &owner
prompt and table name like: &prefix
prompt
prompt          This may take a long time.  Please wait . . .
select
'There are '||count(dbt.table_name)||' tables' buff,
'for owner:  ''&owner'' with names like: ''&prefix''.' buff
from all_tables dbt
where dbt.owner like upper('&owner')
  and dbt.table_name like upper('&prefix');
set termout off
set heading on

ttitle left jobdate jobtime center '&app_name' right 'Page: ' format 999 sql.pno skip 1 -
center 'Tables which may be related to other tables via the definition of a Unique Index' skip 1 -
center 'for Table Names like &prefix and Owner Names like &owner' skip 2

btitle center 'Report: reltbls'

set verify off
set feedback off
spool &output_file

select dbi.table_name tablename1,dbic.column_name columnname1,dbtc.table_name tablename2, dbtc.column_name columnname2
from
     dba_tab_columns dbtc,
     dba_ind_columns dbic,
     dba_indexes dbi
where dbi.table_owner = upper('&owner')
  and dbi.table_name like upper('&prefix')
  and dbic.table_owner = dbi.table_owner
  and dbtc.owner = dbi.table_owner
  and dbic.table_name = dbi.table_name
  and dbtc.table_name like upper('&prefix')
  and dbi.index_name = dbic.index_name
  and dbi.uniqueness = 'UNIQUE'
  and dbtc.column_name like '%'||dbic.column_name||'%'
  and dbtc.table_name != dbi.table_name
order by dbi.table_name,dbic.column_name,dbtc.table_name,dbtc.column_name
/
spool off
set termout on
start &tool_home/ppcmd
exit
