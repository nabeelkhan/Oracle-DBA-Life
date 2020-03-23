REM gncrttpr.sql checked out on 10/18/97 17:05:15 version 1.7
set termout off
set define '^'
REM ---- Enter the Grantor of the privileges to be re-created:%
define grantor= '^1'

REM ---- Enter the Grantee of the privilege or wildcard to match:%
define grantee = '^2'

REM ---- Enter the application name for the report:?
define app_name = '^3'

REM ---- Enter the table name or wildcare to match for the privilege:%
define table='^4'

REM ---- Var '^5' not used

REM ---- Enter the Final output file name:$report_name.sql
define output_file='^6'

REM ---- Var '^7' not used

REM ----- Tool home is where all of the scripts live
define tool_home='/home/marcm/dba_rpt'

REM ----- Temporary file used to run last output
define temp_file = mkcrttpr.sql

set heading off
set feedback off
set embedded on
set pagesize 0
set linesize 132
set verify off

column buff fold_after 1

start ^tool_home/rptvars
set termout on
prompt
prompt Checking tables/roles for grantor: ^grantor
prompt with grantees like ^grantee
prompt with table_names like ^table
prompt
select
'There are '||count(distinct grantee)||' grantee' buff,
'for grantor:  ''^grantor'' with names like: ''^grantee''.' buff
from dba_tab_privs
where grantor like upper('^grantor')
  and table_name like upper('^table')
  and grantee like upper('^grantee');
set termout off

spool ^temp_file

select 
'prompt' buff,
'prompt ' buff,
'column buff fold_after 1' buff,
'set feedback off' buff,
'set termout off' buff,
'set heading off' buff,
'define output_file=^output_file' buff,
'spool ^output_file' buff,
'set termout on' buff,
'prompt REM     Creating SQL Script file ^output_file' buff,
'prompt REM     For application ^app_name' buff, 
'prompt REM     with grantor like ^grantor' buff,
'prompt REM     and grantee names like ^grantee' buff,
'prompt REM     and table names like ^table' buff,
'prompt ' buff,
'set termout off' buff
from dual;
select
'select ''set define ''''&'''''' buff,' buff,
'''set termout on'' buff,' buff,
'''set verify off'' buff' buff,
'from dual;' buff
from dual;

select
distinct 'select ''accept orapass_'||grantor||' char prompt ''''Enter the oracle password for  '||grantor||' :'''' HIDE'' buff'
buff,
'from dual;' buff
from dba_tab_privs
where grantor like upper('^grantor')
and grantee like upper('^grantee')
and table_name like upper('^table');

select 
distinct 'start ^tool_home/crttpr '||grantor||' '||grantee||' ^table'
from dba_tab_privs
where grantor like upper('^grantor')
and grantee like upper('^grantee')
and table_name like upper('^table')
order by 1;

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
rem prompt Running intermediate output file:  ^temp_file
start ^temp_file
set define '^'
host rm ^temp_file
exit
