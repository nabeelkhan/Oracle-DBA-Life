REM gnctl.sql checked out on 7/7/96 17:05:15 version 1.4
set termout off
REM ---- Enter the Owner of the tables or wildcard to match:%
define owner = '&1'

REM ---- Enter the table_name or wildcard to match:%
define prefix = '&2'

REM ---- Enter the name of the application for the comment in the scripts:%
define app_name = '&3'

REM ---- Var '&4 not used

REM ---- Enter the Offset to strip off of the table prefix (e.g PROJ_EMPLOYEES => offset = 6 to get EMPLOYEES ):6
define offset=&5

REM ---- Enter the Prefix to prepend on to file names:test_
define file_prefix='&4'

REM ---- Var '&6' not used

REM ---- Var '&7 not used

REM ----- Home for the utils
define tool_home='/home/marcm/dba_rpt'

rem
rem Created by Marc E. Marchioli
rem in 1990 For his personal use
rem
start &tool_home/pformat
start &tool_home/rptvars

set heading off
set feedback off
set pagesize 0
set linesize 132
set verify off

rem ***** This is the number of characters to strip off the beginning of
rem ***** table name for putting in to the name of the structure
rem *****
rem *****      table_name    ==> structure_name
rem *****                  offset= 6
rem ***** e.g. proj_dual     ==> db_dual.h
rem *****                  offset= 4
rem *****      ext_projects  ==> db_projects
rem *****
define temp_file = make_ctl.sql

column buff fold_after 1
column tab_length new_value tablen
column col_length new_value collength 
column col_len new_value collen 
column commts_len new_value commtslen

set termout on
prompt
prompt ******** Running DBA Create Loader Control Scripts
prompt Creating &file_prefix.XXXXX.ctl files 
prompt for owner: &owner and table name like &prefix
prompt
set termout off

set termout off
spool make_ctl.sql

select 
'prompt Generating SQL loader control files' buff,
'prompt Please wait . . .' buff,
'set termout off' buff
from dual;

select 
'set termout on' buff,
'prompt Creating loader control file for:     '||rpad(table_name,30,' ')||' output file:     &file_prefix'||lower(substr(table_name,&offset))||'.ctl' buff,
'set termout off' buff,
'spool &file_prefix'||lower(substr(table_name,&offset))||'.ctl' buff,
'start &tool_home/ctl '||table_name buff,
'spool off' buff
from all_tables
where table_name like upper('&prefix')
and owner like upper('&owner')
order by table_name;
select 
'set termout on' buff,
'prompt' buff,
'prompt Files complete.'buff,
'prompt' buff
from dual;

spool off
set heading on
set feedback on
set termout on

prompt
prompt Running intermediate output file:  &temp_file
prompt
start &temp_file
host rm &temp_file
exit
