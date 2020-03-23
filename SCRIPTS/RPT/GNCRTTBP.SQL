REM gncrttbp.sql checked out on 12/22/97 17:05:17 version 1.12 created on 12/18/97 09:03:09
set termout off
set define '^'
REM ---- Enter the Owner of the tables to be re-created or wildcard:%
define owner= '^1'

REM ---- Enter the table name or wildcard to match:%
define prefix = '^2'

REM ---- Enter the comment for the script:?
define app_name = '^3'

REM ---- Enter the tablespace name the tables reside in or wildcard to match:%
define tbsp_prefix = '^4'

REM ---- Enter the Switch to compute statistics after creation (y/n):n
define compute_stats='^5'

REM ---- Enter the Final output file name:$report_name.sql
define output_file = '^6'

REM ---- Var '^7' not used

REM ----- Tool home is where all of the scripts live
define tool_home='/home/marcm/dba_rpt'

REM ----- Temporary file used to run last output
define temp_file = mkcrttbp.sql

REM
REM Created by Marc Marchioli, 1995
REM Copyright  1996, 1997 by
REM The DataBase Group, Inc.
REM

set heading off
set feedback off
set embedded on
set pagesize 0
set linesize 132
set verify off

column buff fold_after 1
column ord_col noprint

start ^tool_home/rptvars
set termout on
prompt ******** Running Create DDL 
prompt for Tables at projected size
prompt with owner like:           ^owner
prompt and tablespace name like:  ^tbsp_prefix
prompt and table name like:       ^prefix
prompt
prompt
start ^tool_home/chkobjcn
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
'prompt REM     with owner like ^owner and names like ^prefix' buff,
'prompt ' buff,
'set termout off' buff
from dual;
select
'select ''set define ''''&'''''' buff,' buff,
'''set termout on'' buff,' buff,
'''set verify off''' buff,
'from dual;' buff
from dual;
select
distinct 'select ''accept orapass_'||owner||' char prompt ''''Enter the oracle password for  '||owner||' :'''' HIDE'' buff' buff,
'from dual;' buff
from all_tables
where owner like upper('^owner')
  and tablespace_name like upper('^tbsp_prefix')
  and table_name like upper('^prefix');
select
'set termout off' buff
from dual;

select 'select ''connect '||owner||'/&&orapass_'||owner||''' buff' buff,
'from dual;' buff,
'start ^tool_home/crttabp '||owner||' '||table_name||' ^compute_stats'
from all_tables
where table_name like upper('^prefix')
  and tablespace_name like upper('^tbsp_prefix')
  and owner like upper('^owner')
order by owner,table_name;

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
