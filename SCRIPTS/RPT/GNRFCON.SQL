REM gnrfcon.sql checked out on 12/22/97 17:05:20 version 1.1 created on 8/27/97 13:12:27
set heading off
set feedback off
set pagesize 0
set linesize 132
set verify off
set termout off
set define '^'

REM ---- Enter the Owner of the tables with the Primary/Unique key or wildcard to match:%
define owner= '^1'

REM ---- Enter the tablespace name the Primary/Unique keys reside in or wildcard to match:%
define tbsp_prefix = '^2'

REM ---- Enter the Title for the comments in the script:?
define app_name = '^3'

REM ---- Enter the table name the Primary/Unique keys are on or wildcard to match:%
define prefix = '^4'

REM ---- Enter the Switch to compress extents or use default size (Y,y => compress):y
define switch='^5'

REM ---- Enter the Final output file name for the script:$report_name.sql
define output_file = '^6'

REM ---- Var '^7' not used

REM ----- Tool home is where all of the scripts live
define tool_home='/home/marcm/dba_rpt'

REM ----* Temporary file used to run last output
define temp_file = mkrfcon.sql

start ^tool_home/rptvars

column file_name fold_after 1
column buff fold_after 1
column struct_name fold_after 1
column col_len new_value collen
column col_name new_value colname
column ord_col noprint


set feedback on
set termout on
prompt
prompt ******* CAUTION: This script will overlook constraints
prompt                  which have indexes with different names
prompt                  enforcing the constraints 
prompt                  (e.g. INDEX_NAME != CONSTRAINT_NAME)
prompt
prompt  The following will be ignored:
prompt
select 
/* list constraints which have indexes with different names enforcing the constraint for the wildcards */
owner||'.'||table_name||' '||decode(constraint_type, 'U', 'Unique key ', 'P', 'Primary key ', constraint_type)||constraint_name
from
     all_constraints ac
where ac.owner like upper('^owner')
  and ac.table_name like upper('^prefix')
  and ac.constraint_type in ('P','U')
  and not exists (select null
		from all_indexes ai
		where ai.table_name = ac.table_name
		  and ai.owner = ac.owner
		  and ai.index_name = ac.constraint_name)
;
set feedback off

prompt Checking constraints on tables 
prompt for owner like:              ^owner
prompt and table space name like:   ^tbsp_prefix
prompt and table name like:         ^prefix
prompt
prompt (this may take a while depending on DB size)
prompt

select 1 ord_col,
'There are '||count(atb.table_name)||' tables, ' buff
from
	 all_tables atb
where atb.owner like upper('^owner')
  and atb.table_name like upper('^prefix')
  and atb.tablespace_name like upper('^tbsp_prefix')
union
select 2 ord_col,
count(ai.index_name)||' indexes' buff
from 
     all_indexes ai
where ai.owner like upper('^owner')
  and ai.table_name like upper('^prefix')
  and ai.tablespace_name like upper('^tbsp_prefix')
  and not exists (select null 
		  from all_constraints ac 
		  where ai.index_name = ac.constraint_name 
		    and ac.owner = ai.owner 
		    and ac.table_name = ai.table_name 
		    and constraint_type in ('P','U'))
  union
select 3 ord_col,
/* get the owners that have Referential constraints referencing the Primary/Unique keys for the wildcards */
count(ac.constraint_name)||' '||decode(constraint_type, 'C', 'Check', 'R', 'Referential', 'U', 'Unique key', 'P', 'Primary key',
constraint_type)||' constraints' buff
from 
	 all_indexes ai,
	 all_constraints ac
where ac.owner like upper('^owner')
  and ac.constraint_type in ('P','U')
  and ac.constraint_name = ai.index_name
  and ac.owner = ai.owner
  and ai.table_name like upper('^prefix')
  and ai.tablespace_name like upper('^tbsp_prefix')
group by constraint_type
union
select 4 ord_col,
/* get the constraints which have indexes with different names enforcing the constraint for the wildcards */
count(ac.constraint_name)||' '||decode(constraint_type, 'C', 'Check', 'R', 'Referential', 'U', 'Unique key', 'P', 'Primary key',
constraint_type)||' constraints ARE ENFORCED where INDEXE_NAME != CONSTRAINT_NAME' buff
from 
	all_constraints ac
where ac.owner like upper('^owner')
  and ac.table_name like upper('^prefix')
  and ac.constraint_type in ('P','U')
  and not exists (select null
 		  from all_indexes ai
           	  where ai.table_name = ac.table_name
		    and ai.owner = ac.owner
		    and ai.index_name = ac.constraint_name)
group by constraint_type
union
select 5 ord_col,
/* get the owners that have Referential constraints referencing the Primary/Unique keys for the wildcards */
count(ac.constraint_name)||' foreign key constraints referencing these primary/unique keys.' buff
from 
	all_indexes ai,
	all_constraints ac
where ac.r_owner like upper('^owner')
  and ai.owner = ac.r_owner
  and ac.constraint_type  = 'R'
  and ai.table_name like upper('^prefix')
  and ac.r_constraint_name = ai.index_name
  and ai.tablespace_name like upper('^tbsp_prefix')
union
select 6 ord_col,
'for owner:  ''^owner'' in tablespace name like: ''^tbsp_prefix'' with table_names like: ''^prefix''.' buff
from dual
order by 1;
prompt
set termout off

spool ^temp_file

select 'prompt Creating SQL Script file ^output_file' buff,
'prompt for application ^app_name' buff,
'prompt ' buff,
'column buff fold_after 1' buff,
'set feedback off' buff,
'set termout off' buff,
'set define ''%''' buff,
'define output_file=^output_file' buff,
'spool %output_file' buff
from dual;
select
'select ''set define ''''&'''''' buff,' buff,
'''set termout on'' buff,' buff,
'''set verify off'' buff' buff,
'from dual;' buff
from dual;
select
/* get Primary/Unique key owners for the wildcards given */
distinct 'select ''accept orapass_'||ac.owner||' char prompt ''''Enter the oracle password for  '||ac.owner||' :'''' HIDE'' buff' buff,
'from dual;' buff
from 
	all_indexes ai,
	all_constraints ac
where ai.owner like upper('^owner')
  and ai.table_name like upper('^prefix')
  and ai.tablespace_name like upper('^tbsp_prefix')
  and ac.owner = ai.owner
  and ac.constraint_name = ai.index_name
  and ac.constraint_type in  ('P','U')
union
select
/* get the owners that have Referential constraints referencing the Primary/Unique keys for the wildcards */
distinct 'select ''accept orapass_'||ac.owner||' char prompt ''''Enter the oracle password for  '||ac.owner||' :'''' HIDE'' buff'
buff,
'from dual;' buff
from 
	all_indexes ai,
	all_constraints ac
where ac.r_owner like upper('^owner')
  and ai.owner = ac.r_owner
  and ac.constraint_type  = 'R'
  and ai.table_name like upper('^prefix')
  and ac.r_constraint_name  = ai.index_name
  and ai.tablespace_name like upper('^tbsp_prefix')
;
select
'set termout off' buff
from dual;

select 
/** generate the foreign key drops **/
'select ''connect '||dbc.owner||'/&&orapass_'||dbc.owner||''' buff from dual;' buff,
'start ^tool_home/dropcns '||dbc.owner||' '||dbc.table_name||' '||dbc.constraint_name||' ^switch'
from 
     all_constraints dbc,
     all_indexes ai
where dbc.r_owner like upper('^owner')
  and dbc.constraint_type = 'R'
  and ai.table_name like upper('^prefix')
  and dbc.r_constraint_name = ai.index_name
  and ai.tablespace_name like upper('^tbsp_prefix')
order by dbc.owner,ai.table_name,dbc.constraint_name;
select 
/** generate the primary key drops **/
'select ''connect '||dbc.owner||'/&&orapass_'||dbc.owner||''' buff from dual;' buff,
'start ^tool_home/crtkycns '||dbc.owner||' '||ai.table_name||' '||dbc.constraint_name||' ^switch'
from 
		 all_constraints dbc,
		 all_indexes ai
where ai.owner like upper('^owner')
  and ai.table_name like upper('^prefix')
  and ai.tablespace_name like upper('^tbsp_prefix')
  and dbc.constraint_type in ('P','U')
  and dbc.constraint_name = ai.index_name
  and dbc.owner = ai.owner
order by dbc.owner,ai.table_name,dbc.constraint_name;

select 
/** generate the primary keys **/
'select ''connect '||dbc.owner||'/&&orapass_'||dbc.owner||''' buff from dual;' buff,
'start ^tool_home/crtkycns '||dbc.owner||' '||ai.table_name||' '||dbc.constraint_name||' ^switch'
from 
	all_constraints dbc,
	all_indexes ai
where ai.owner like upper('^owner')
  and ai.table_name like upper('^prefix')
  and ai.tablespace_name like upper('^tbsp_prefix')
  and dbc.constraint_type in ('P','U')
  and dbc.constraint_name = ai.index_name
  and dbc.owner = ai.owner
order by dbc.owner,ai.table_name,dbc.constraint_name;
select 
/** generate the foreign keys **/
'select ''connect '||dbc.owner||'/&&orapass_'||dbc.owner||''' buff from dual;' buff,
'start ^tool_home/crtrecns '||dbc.owner||' '||dbc.table_name||' '||dbc.constraint_name||' ^switch'
from 
     all_constraints dbc,
     all_indexes ai
where dbc.r_owner like upper('^owner')
  and dbc.constraint_type = 'R'
  and ai.table_name like upper('^prefix')
  and dbc.r_constraint_name = ai.index_name
  and ai.tablespace_name like upper('^tbsp_prefix')
order by dbc.owner,ai.table_name,dbc.constraint_name;

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
prompt
start ^temp_file
REM must redefine the define character since the temp_file script
REM changed its definition
set define '^'
host rm ^temp_file
exit
