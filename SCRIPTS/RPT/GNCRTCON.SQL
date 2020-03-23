REM gncrtcon.sql checked out on 12/22/97 17:05:14 version 1.11 created on 9/23/97 16:41:44
set heading off
set feedback off
set pagesize 0
set linesize 132
set verify off
set termout off
set define '^'

REM ---- Enter the Owner of the tables or wildcard to match:%
define owner= '^1'

REM ---- Enter the table name or wildcard to match:%
define prefix = '^2'

REM ---- Enter the Title for the comments in the script:?
define app_name = '^3'

REM ---- Enter the Switch to compress extents or use default size (Y,y => compress):y
define switch='^4'

REM ---- Var '^5' not used

REM ---- Enter the Final output file name for the script:$report_name.sql
define output_file = '^6'

REM ---- Var '^7' not used

REM ----- Tool home is where all of the scripts live
define tool_home='/home/marcm/dba_rpt'

REM ----- Temporary file used to run last output
define temp_file = mkcrtcon.sql

start ^tool_home/rptvars

column file_name fold_after 1
column buff fold_after 1
column struct_name fold_after 1
column col_len new_value collen 
column col_name new_value colname

REM -- loads a temp table for screening out the check constraints that are
REM -- for not null condition.  This is complicated since the search_condition
REM -- clause is a LONG.  Thus, we can't perform any type of function on it.

column temp_data new_value tmp_data noprint;
column log_file new_value tmp_log noprint;
column bad_file new_value tmp_bad noprint;
column user_name new_value username noprint;

select '/tmp/ldckcon_'||userenv('SESSIONID')||'.dat' temp_data,
       '/tmp/ldckcon_'||userenv('SESSIONID')||'.log' log_file,
       '/tmp/ldckcon_'||userenv('SESSIONID')||'.bad' bad_file,
      decode(substr(user,1,length(value)),upper(value),'/',user) user_name
from v$parameter
where name = 'os_authent_prefix';


create table gncrtcon (
	owner varchar2(30) not null,
	table_name varchar2(30) not null,
	constraint_name varchar2(30) not null,
	constraint_text varchar2(42) not null )
storage ( initial 800 K next 100 K ) ;
create unique index gncrtcon_prime on gncrtcon(owner,table_name,constraint_name)
storage ( initial 800 K next 100 K);

delete from gncrtcon
where owner like upper('^owner')
  and table_name like upper('^prefix');
commit;

start ^tool_home/ldckcon ^tmp_data
set termout on
PROMPT Loading Temporary table for Check constraints using SQL*Loader
host sqlldr userid=^username data=^tmp_data log=^tmp_log bad=^tmp_bad control=^tool_home/ldckcon.ctl 
set termout off
host rm ^tmp_data ^tmp_log

column ord_col noprint

set termout on
prompt
prompt Checking constraints on tables for owner: ^owner
prompt
select 1 ord_col,
'There are '||count(dbt.table_name)||' tables,' buff
from all_tables dbt
where dbt.owner like upper('^owner')
  and dbt.table_name like upper('^prefix')
union
select 2 ord_col,
count(ai.index_name)||' indexes and ' buff
from
		 all_indexes ai
where ai.owner like upper('^owner')
  and ai.table_name like upper('^prefix')
union
select 3 ord_col,
count(dbc.constraint_name)||' '||decode(constraint_type, 'C', 'Check', 'R', 'Foreign Key', 'U', 'Unique Key', 'P', 'Primary Key', constraint_type)||' constraints' buff
from dba_constraints dbc
where dbc.owner like upper('^owner')
  and dbc.table_name like upper('^prefix')
  and dbc.constraint_name not in (select constraint_name 
				  from gncrtcon gc 
				  where gc.owner = dbc.owner
  				    and gc.table_name = dbc.table_name
				    and gc.constraint_text like '% IS NOT NULL')
group by constraint_type
union
select 4 ord_col,
'for owner:  ''^owner'' with table_names like: ''^prefix''.' buff
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
distinct 'select ''accept orapass_'||owner||' char prompt ''''Enter the oracle password for  '||owner||' :'''' HIDE'' buff' buff,
'from dual;' buff
from all_tables
where owner like upper('^owner')
  and table_name like upper('^prefix');
select
'set termout off' buff
from dual;

select 'select ''connect '||owner||'/&&orapass_'||owner||''' buff' buff,
'from dual;' buff,
'start ^tool_home/dropcns '||owner||' '||table_name||' '||constraint_name buff,
'start ^tool_home/'||decode(constraint_type,'C','crtckcns ','R','crtrecns ','F','crtfcns ','crtkycns ')||owner||' '||table_name||' '||constraint_name||' ^switch' buff
from dba_constraints dbc
where table_name like upper('^prefix')
  and owner like upper('^owner')
  and dbc.constraint_name not in (select constraint_name 
				  from gncrtcon gc 
				  where gc.owner = dbc.owner
  				    and gc.table_name = dbc.table_name
				    and gc.constraint_text like '% IS NOT NULL')
order by owner,table_name,constraint_name;

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
