REM gncrtdb.sql checked out on 10/18/97 17:05:14 version 1.5
set termout off
set define '^'
REM ---- Enter the database name or wildcard to match:%
define prefix = '^1'

REM ---- Var ^2 not used

REM ---- Var '^3' not used

REM ---- Var ^4  not used

REM ---- Var ^5  not used

REM ---- Enter the Final output file name for the script:$report_name.sql
define output_file = '^6'.sql

REM ---- Var ^7  not used

REM ----- Tool home is where all of the scripts live
define tool_home='/home/marcm/dba_rpt'

REM ----- Temporary file used to run last output
define temp_file = mkcrtdb.sql

set heading off
set feedback off
set pagesize 0
set space 0
set embedded on
set verify off

column buff fold_after 1

set termout on
prompt
prompt Checking Databases for instance like: ^prefix
prompt
select
'There are '||count(name)||' databases' buff,
'with names like: ''^prefix''.' buff
from v$database 
where name like upper('^prefix');

set termout off

start ^tool_home/rptvars

spool ^temp_file

select 
'prompt' buff,
'prompt Creating SQL Script file ^output_file' buff,
'prompt ' buff,
'column buff fold_after 1' buff,
'set feedback off' buff,
'set termout off' buff,
'set heading off' buff,
'set define ''$''' buff,
'define output_file=^output_file' buff,
'spool $output_file' buff,
'set termout off' buff
from dual;
select 
'start ^tool_home/crtdb '||name
from v$database
where name like upper('^prefix')
order by name;
set space 1
select distinct 'start ^tool_home/crtdblog',group#
from v$logfile
order by group#;
select 'select '';'' from dual;' from dual;
select
'spool off' buff,
'set termout on' buff,
'prompt' buff,
'set define ''&''' buff,
'start ^tool_home/ppcmd' buff,
'prompt' buff
from dual;

spool off

set heading on
set feedback on
set termout on
prompt Running intermediate output file:  ^temp_file
start ^temp_file
set define '^'
host rm ^temp_file
exit
