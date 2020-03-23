REM gncrtvw.sql checked out on 10/18/97 17:05:15 version 1.7
set termout off
set define '^'
REM ---- Enter the Owner of the views or wildcard to match:%
define owner= '^1'

REM ---- Enter the view name or wildcard to match:%
define prefix = '^2'

REM ---- Enter the Title for the comment in the script:?
define app_name = '^3'

REM ---- Var '^4' not used

REM ---- Var '^5' not used

REM ---- Enter the Final output file name:$report_name.sql
define output_file = '^6'

REM ---- Var '^7' not used

REM ----- Tool home is where all of the scripts live
define tool_home='/home/marcm/dba_rpt'

REM ----- Temporary file used to run last output
define temp_file = mkcrtvw.sql

set heading off
set feedback off
set embedded on
set pagesize 0
set linesize 132
set verify off

column buff fold_after 1
column max_text_length new_value max_length noprint;

start ^tool_home/rptvars
set termout on
prompt
prompt Checking views for owner: ^owner
prompt
select
'There are '||count(dbv.view_name)||' views' buff,
'for owner:  ''^owner'' with names like: ''^prefix''.' buff
from all_views dbv
where dbv.owner like upper('^owner')
  and dbv.view_name like upper('^prefix');
set termout off

select max(text_length)+1 max_text_length 
from all_views
where owner like upper('^owner')
  and view_name like upper('^prefix');

spool ^temp_file

select 
'prompt' buff,
'prompt ' buff,
'column buff fold_after 1' buff,
'set feedback off' buff,
'set termout off' buff,
'set heading off' buff,
'set long ^max_length' buff,
'column text format a130 word_wrapped' buff,
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
'''set verify off'' buff ' buff,
'from dual;' buff
from dual;
select
distinct 'select ''accept orapass_'||owner||' char prompt ''''Enter the oracle password for  '||owner||' :'''' HIDE'' buff' buff,
'from dual;' buff
from all_views
where owner like upper('^owner')
  and view_name like upper('^prefix');
select
'set termout off' buff
from dual;

select 'select ''connect '||owner||'/&&orapass_'||owner||''' buff' buff,
'from dual;' buff,
'start ^tool_home/crtview '||owner||' '||view_name
from all_views
where view_name like upper('^prefix')
and owner like upper('^owner')
order by owner,view_name;

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
