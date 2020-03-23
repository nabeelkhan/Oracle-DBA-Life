REM gncrtdbl.sql checked out on 10/12/99 12:18:17 version 1.5
set termout off
set define '^'
REM ---- Enter the Database link owner of the database links to be re-created:%
define owner= '^1'

REM ---- Enter the database link name or wildcard to match:%
define link_name = '^2'

REM ---- Enter the application name for the report:?
define app_name = '^3'

REM ---- Enter the link login userid of the database link or wildcard to match:%
define link_userid ='^4'

REM ---- Enter the host  name the database link is for or wildcard to match:%
define host_id = '^5'

REM ---- Enter the Final output file name:$report_name.sql
define output_file='^6'


REM ----- Tool home is where all of the scripts live
define tool_home='/home/marcm/dba_rpt'

REM ----- Temporary file used to run last output
define temp_file = mkcrtdbl.sql

set heading off
set feedback off
set embedded on
set pagesize 0
set linesize 132
set verify off

column buff fold_after 1

start ^tool_home/rptvars
column temp_userid_text new_value userid_text noprint;
column temp_host_text new_value host_text noprint;
 
 select
 decode('^link_userid', '%', '(l.userid like upper(''^link_userid'') or l.userid is null)', 'l.userid = ''^link_userid''')
 temp_userid_text,
 decode('^host_id', '%', '(l.host like upper(''^host_id'') or l.host is null)', 'l.host = ''^host_id''') temp_host_text
 from dual;

set termout on
prompt
Prompt This Script was created by Nabeel Khan
prompt for his personal use...Don't use it with
prompt with out his permission!!!
Pause
prompt
prompt **** Generating  SQL to create database links owned by: ^owner
prompt with database link names like: ^link_name
prompt with user id's like:  ^link_userid
prompt with host names like:   ^host_id
prompt
select
'There are '||count(u.name)||' database links' buff,
'owned by:  ''^owner''' buff,
'with names like: ''^link_name''' buff,
'for link user id like: ''^link_userid''' buff,
'and host names like: ''^host_id''' buff
from sys.link$ l, sys.user$ u
where l.owner# = u.user#
  and u.name like upper('^owner')
  and l.name like upper('^link_name')
  and ^userid_text
  and ^host_text
  ;
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
'prompt REM     Creating SQL Script database links file ^output_file' buff,
'prompt REM     For application:                        ^app_name' buff, 
'prompt REM     for owner like:                         ^owner' buff,
'prompt REM     owning database link with names like    ^link_name' buff,
'prompt REM     for user id like:                       ^link_userid' buff,
'prompt REM     and host names like:                    ^host_id' buff,
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
distinct 'select ''accept orapass_'||decode(u.name,'PUBLIC','SYSTEM',u.name)||' char prompt ''''Enter the oracle password for  '||decode(u.name,'PUBLIC','SYSTEM',u.name)||' :'''' HIDE'' buff'
buff,
'from dual;' buff
from sys.link$ l, sys.user$ u
where l.owner# = u.user#
  and u.name like upper('^owner');

select 
'start ^tool_home/crtdbl '||u.name||' '||l.name
from sys.link$ l, sys.user$ u
where l.owner# = u.user#
and  u.name like upper('^owner')
and l.name like upper('^link_name')
and nvl(l.userid,'*') like upper('^link_userid')
and nvl(l.host,'*') like upper('^host_id')
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
