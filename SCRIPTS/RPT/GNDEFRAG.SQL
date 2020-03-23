REM gndefrag.sql checked out on 1/18/97 17:05:18 version 1.3
set termout off
REM ---- Enter the tablespace name to coalesce ( or wildcard ):%
define tablespace_name= '&1'

REM ---- Enter the application or database name for the comment in script:?
define app_name= '&2'

REM ---- Var '&3' not used

REM ---- Var '&4' not used

REM ---- Var '&5' not used

REM ---- Enter the  output file name for the script:$report_name.sql
define output_file = '&6'

REM ---- Var '&7' not used

REM ----- The home directory for the script files
define tool_home='/home/marcm/dba_rpt'

set pagesize 0
set linesize 132
set verify off
set feedback off

column buff fold_after 1 word_wrapped

set termout on
prompt
prompt Generating  SQL script 
prompt to coalesce ONLINE tablespaces
prompt  for tablespace name like &tablespace_name
prompt
select
'There are '||count(name)||' tablespaces ONLINE' buff,
'with tablespace names like: ''&tablespace_name''.' buff
from sys.ts$
where name like upper('&tablespace_name')
  and online$ = 1;
set termout off

start &tool_home/rptvars
spool &output_file
select 'set termout on' buff,
'Prompt SQL script to coalesce ONLINE tablespaces for name like &tablespace_name' buff,
'Prompt for application: &app_name' buff,
'Prompt ' buff
from dual;
select 
'Prompt Coalescing tablespace '||name buff,
'alter session set events ''immediate trace name coalesce level '||ts#||''';' buff
from sys.ts$
where name like upper('&tablespace_name')
  and online$ = 1
order by name;
spool off
set feedback on
set termout on
start &tool_home/ppcmd
exit
