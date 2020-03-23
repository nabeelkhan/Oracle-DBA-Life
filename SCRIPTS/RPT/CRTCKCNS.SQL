REM crtckcns.sql checked out on 12/22/97 17:05:12 version 1.4 created on 8/27/97 13:11:39
set heading off
set verify off
set embedded on
set pagesize 0
set linesize 132
set arraysize 2
set space 0
set wrap off
set define '^'
column search_condition_sw format a42 new_value condition_text noprint
column search_condition format a100 word_wrapped 
column constraint_name_sw format a30 new_value constraint_sw noprint
column sum_bytes new_value tot_bytes noprint;

REM select search_condition search_condition_sw
REM from dba_constraints dbc
REM where table_name = upper('^2')
REM   and constraint_name = upper('^3')
REM   and owner = upper('^1');
REM 

select constraint_name constraint_name_sw 
from dba_constraints dbc
where table_name = upper('^2')
and constraint_name = upper('^3')
and owner = upper('^1');

REM and constraint_name not like 'SYS_C%'

select sum(bytes)/1024 sum_bytes
from dba_extents
where segment_name = upper('^3')
  and owner = upper('^1');

set termout on
prompt REM Generating create SQL for: ^1..^2     check constraint:   ^3
set termout off

REM select
REM 'REM Check constraint not generated since it is a NOT NULL constraint' buff,
REM 'REM and will be created via the create table statement'
REM from dual
REM where '^condition_text' like '%IS NOT NULL';

select 
'prompt Creating constraint on Table: '||upper('^2')||' Constraint: '||'^constraint_sw' buff,
'ALTER TABLE '||upper('^2')||' ADD CONSTRAINT '||'^constraint_sw'||' CHECK ('
 from dba_constraints
where constraint_name = upper('^3')
  and table_name = upper('^2')
  and owner = upper('^1');
REM  and '^condition_text' not like '%IS NOT NULL';
select 
'     ',search_condition
 from dba_constraints
where constraint_name = upper('^3')
  and table_name = upper('^2')
  and owner = upper('^1');
REM  and '^condition_text' not like '%IS NOT NULL';
select
'     )'||decode(status,'DISABLED',' DISABLE;','ENABLED',';')
 from dba_constraints
where constraint_name = upper('^3')
  and table_name = upper('^2')
  and owner = upper('^1');
REM  and '^condition_text' not like '%IS NOT NULL';

