REM gncrtrbk.sql checked out on 10/18/97 17:05:14 version 1.7
set define '^'
REM ---- Enter the Owner of the rollback segments or wildcard to match:%
define owner= '^1'

REM ---- Enter the tablespace name or wildcard to match:%
define prefix = '^2'

REM ---- Enter the Title for the comment in the script:?
define app_name = '^3'

REM ---- Enter the rollback segment name or wildcard to match:%
define roll_prefix = '^4'

REM ---- Enter the Switch to compress extents (Y, y => Compress):y
define switch=^5

REM ---- Enter the Final output file name for the script:$report_name.sql
define output_file = '^6'

REM ---- Var '^7' not used

REM ----- Tool home is where all of the scripts live
define tool_home='/home/marcm/dba_rpt'

REM ----- Temporary file used to run last output
define temp_file = mkcrtrbk.sql

set heading off
set feedback off
set embedded on
set pagesize 0
set linesize 132
set verify off
set termout off

column buff fold_after 1

set termout on
prompt
prompt Checking rollback segments for owner: ^owner
prompt
select
'There are '||count(dbr.segment_name)||' rollback segments' buff,
'for owner:  ''^owner'' with names like: ''^prefix''.' buff,
'and with segment names like: ''^roll_prefix''.' buff
from dba_rollback_segs dbr
where dbr.owner like upper('^owner')
  and dbr.tablespace_name like upper('^prefix')
  and dbr.segment_name like upper('^roll_prefix');
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
'set termout on' buff,
'prompt REM     Creating SQL Script file ^output_file' buff,
'prompt REM     For application            ^app_name' buff,
'prompt REM     with owner like            ^owner ' buff,
'prompt REM      and tablespace names like ^prefix' buff,
'prompt REM      and rollback names like   ^roll_prefix' buff,
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
distinct 'select ''accept orapass_'||owner||' char prompt ''''Enter the oracle password for  '||owner||' :'''' HIDE'' buff' buff,
'from dual;' buff
from dba_rollback_segs
where owner like upper('^owner');
select
'set termout off' buff
from dual;

select 'select ''connect '||owner||'/&&orapass_'||owner||''' buff' buff,
'from dual;' buff,
'start ^tool_home/crtrbk '||owner||' '||segment_name||' '||tablespace_name||' ^switch'
from dba_rollback_segs
where tablespace_name like upper('^prefix')
and segment_name like upper('^roll_prefix')
and owner like upper('^owner')
order by owner,tablespace_name, segment_name;

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
