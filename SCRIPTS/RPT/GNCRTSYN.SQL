REM gncrtsyn.sql checked out on 10/18/97 17:05:14 version 1.6
set termout off
set define '^'
REM ---- Enter the Synonym owner of the synonyms to be re-created:%
define owner= '^1'

REM ---- Enter the synonym name or wildcard to match:%
define syn_name = '^2'

REM ---- Enter the application name for the report:?
define app_name = '^3'

REM ---- Enter the table owner the synonym is for or wildcard to match:%
define tab_owner ='^4'

REM ---- Enter the table name the synonym is for or wildcard to match:%
define tab_prefix = '^5'

REM ---- Enter the Final output file name:$report_name.sql
define output_file='^6'

REM ---- Var '&7' not used

REM ----- Tool home is where all of the scripts live
define tool_home='/home/marcm/dba_rpt'

REM ----- Temporary file used to run last output
define temp_file = mkcrtsyn.sql

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
prompt **** Generating  SQL to create synonyms owned by: ^owner
prompt with synonym names like: ^syn_name
prompt with table owners like:  ^tab_owner
prompt with table names like:   ^tab_prefix
prompt
select
'There are '||count(synonym_name)||' synonyms' buff,
'owned by:  ''^owner''' buff,
'with names like: ''^syn_name''' buff,
'for table owners like: ''^tab_owner''' buff,
'and table names like: ''^tab_prefix''' buff
from all_synonyms
where owner like upper('^owner')
  and synonym_name like upper('^syn_name')
  and table_owner like upper('^tab_owner')
  and table_name like upper('^tab_prefix');
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
'prompt REM     Creating SQL Script grant file        ^output_file' buff,
'prompt REM     For application:                      ^app_name' buff, 
'prompt REM     for owner like:                       ^owner' buff,
'prompt REM     owning synonyms with names like       ^syn_name' buff,
'prompt REM     for tables owned by owner names like: ^tab_owner' buff,
'prompt REM     and table names like:                 ^tab_prefix' buff,
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
distinct 'select ''accept orapass_'||decode(owner,'PUBLIC','SYSTEM',owner)||' char prompt ''''Enter the oracle password for  '||decode(owner,'PUBLIC','SYSTEM',owner)||' :'''' HIDE'' buff'
buff,
'from dual;' buff
from all_synonyms
where owner like upper('^owner')
and synonym_name like upper('^syn_name')
and table_owner like upper('^tab_owner')
and table_name like upper('^tab_prefix');

select 
distinct 'start ^tool_home/crtsyn '||owner||' '||synonym_name
from all_synonyms
where owner like upper('^owner')
and synonym_name like upper('^syn_name')
and table_owner like upper('^tab_owner')
and table_name like upper('^tab_prefix')
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
