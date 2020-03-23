REM crtrecns.sql checked out on 3/27/96 17:05:12 version 1.3
set heading off
set verify off
set embedded on
set pagesize 0
set linesize 132
set arraysize 2
set space 0
set wrap off
set define '^'
column f_max_column_position new_value f_max_position noprint;
column p_max_column_position new_value p_max_position noprint;
column sum_bytes new_value tot_bytes noprint;

select max(position) p_max_column_position
from dba_cons_columns dbcc,
     dba_constraints dbc
where dbc.table_name = upper('^2')
  and dbcc.owner = dbc.r_owner
  and dbc.constraint_name = upper('^3')
  and dbcc.constraint_name = dbc.r_constraint_name
  and dbc.owner = upper('^1');

select max(position) f_max_column_position
from dba_cons_columns
where table_name = upper('^2')
  and constraint_name = upper('^3')
  and owner = upper('^1');

select sum(bytes)/1024 sum_bytes
from dba_extents
where segment_name = upper('^3')
  and owner = upper('^1');

set termout on
prompt REM Generating create SQL for: ^1..^2     foreign constraint:   ^3
set termout off

select 
'ALTER TABLE '||upper('^2')||' ADD CONSTRAINT '||upper('^3')||' FOREIGN KEY ('
 from dba_constraints
where constraint_name = upper('^3')
  and table_name = upper('^2')
  and owner = upper('^1');

select
'       '||rpad(column_name,35,' ')||decode(position,^f_max_position,')',',')
from dba_cons_columns 
where table_name = upper('^2')
  and constraint_name = upper('^3')
  and owner = upper('^1')
order by position;
select
' REFERENCES '||dbc.r_owner||'.'||dbcc.table_name||' (' buff
from dba_cons_columns dbcc,
     dba_constraints dbc
where dbc.table_name = upper('^2')
  and dbcc.owner = dbc.r_owner
  and dbc.constraint_name = upper('^3')
  and dbcc.constraint_name = dbc.r_constraint_name
  and dbc.owner = upper('^1')
  and position = 1;
select
'       '||rpad(column_name,35,' ')||decode(position,^p_max_position,')'||decode(delete_rule,'NO ACTION',' ',' ON DELETE '||delete_rule)||decode(status,'DISABLED','DISABLE','ENABLED','')||';',',')
from dba_cons_columns dbcc,
     dba_constraints dbc
where dbc.table_name = upper('^2')
  and dbcc.owner = dbc.r_owner
  and dbc.constraint_name = upper('^3')
  and dbcc.constraint_name = dbc.r_constraint_name
  and dbc.owner = upper('^1')
order by position;
