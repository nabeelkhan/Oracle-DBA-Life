REM gncrtind.sql checked out on 12/18/97 17:05:14 version 1.15
set define '^'
REM ---- Enter the Owner of the tables that the indexes are on:%
define owner= '^1'

REM ---- Enter the table name or wildcard with the indexes:%
define prefix = '^2'

REM ---- Enter the Title for the comment in the script file:?
define app_name = '^3'

REM ---- Enter the tablespace name that the indexes reside in or wildcard to match:%
define tbsp_prefix = '^4'

REM ---- Enter the Switch to compute statistics after creation (y/n):n
define compute_stats='^5'

REM ---- Enter the Final output file name for the script:$report_name.sql
define output_file = '^6'

REM ---- Enter the Switch to compress extents or use default (Y,y => Compress):y
define switch='^7'

REM ----- Tool home is where all of the scripts live
define tool_home='/home/marcm/dba_rpt'

REM ----- Temporary file used to run last output
define temp_file = mkcrtind.sql

REM
REM Created by Marc Marchioli, 1995
REM Copyright by 
REM The DataBase Group, Inc. 1996, 1997
REM


set heading off
set feedback off
set pagesize 0
set linesize 132
set verify off
set termout off

column buff fold_after 1
column ord_col noprint

start ^tool_home/rptvars
set termout on
prompt ******** Running Create DDL for indexes 
prompt on tables 
prompt with owner like:           ^owner
prompt and tablespace name like:  ^tbsp_prefix
prompt and table name like:       ^prefix
prompt
start ^tool_home/chkobjcn
set termout off

spool ^temp_file

select 'prompt Creating SQL Script file ^output_file' buff,
'prompt ' buff,
'column buff fold_after 1' buff,
'set feedback off' buff,
'set termout off' buff,
'define output_file=^output_file' buff,
'spool ^output_file' buff
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
from all_indexes dbi
where dbi.owner like upper('^owner')
  and dbi.table_name like upper('^prefix')
  and dbi.tablespace_name like upper('^tbsp_prefix')
  and dbi.index_name not in (select constraint_name 
			     from all_constraints dbc 
			     where dbc.owner = dbi.owner 
			       and dbc.table_name = dbi.table_name
			       and dbc.constraint_type in ('P','U')
			       );

select
'set termout off' buff
from dual;

select
'select ''connect '||dbi.owner||'/&&orapass_'||dbi.table_owner||''' buff' buff,
'from all_indexes dbi' buff,
'where dbi.owner = '''||dbi.owner||'''' buff,
'  and dbi.table_name like upper(''^prefix'')' buff,
'  and dbi.index_name not in (select constraint_name ' buff,
'                             from all_constraints dbc ' buff,
'                             where dbc.owner = dbi.owner' buff,
'                               and dbc.table_name = dbi.table_name' buff,
'			        and dbc.constraint_type in (''P'',''U''))' buff,
'  and dbi.index_name = '''||dbi.index_name||'''' buff,
'  and '''||dbi.index_name||''' = (select min(dbi2.index_name) from all_indexes dbi2' buff,
'                         where dbi2.owner = '''||dbi.owner||'''' buff,
'                           and dbi2.table_name like upper(''^prefix'')' buff,
'                           and dbi2.tablespace_name like upper(''^tbsp_prefix'')' buff,
'                           and dbi2.index_name not in (select constraint_name ' buff,
'                             from all_constraints dbc ' buff,
'                             where dbc.owner = dbi2.owner' buff,
'                               and dbc.table_name = dbi2.table_name' buff,
'			        and dbc.constraint_type in (''P'',''U''))' buff,
'                         );' buff,
'start ^tool_home/crtind '||dbi.table_owner||' '||dbi.table_name||' '||dbi.index_name||' ^switch ^compute_stats 1' buff
from
     all_indexes dbi
where dbi.table_name like upper('^prefix')
  and dbi.owner like upper('^owner')
  and dbi.tablespace_name like upper('^tbsp_prefix')
  and dbi.index_name not in (select constraint_name 
			     from all_constraints dbc 
			     where dbc.owner = dbi.owner
                               and dbc.table_name = dbi.table_name
			       and dbc.constraint_type in ('P','U'))
order by dbi.owner, dbi.table_name, dbi.index_name;


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
