REM crtkycns.sql checked out on 12/22/97 17:05:12 version 1.4 created on 8/27/97 13:11:40
set heading off
set verify off
set embedded on
set pagesize 0
set linesize 132
set arraysize 2
set space 0
set wrap off
set define '^'
column max_column_position new_value max_position noprint;
column sum_bytes new_value tot_bytes noprint;

select max(position) max_column_position
from dba_cons_columns
where table_name = upper('^2')
  and constraint_name = upper('^3')
  and owner = upper('^1');

select nvl(sum(bytes),0)/1024 sum_bytes
from dba_extents
where segment_name = upper('^3')
  and owner = upper('^1');

set termout on
prompt REM Generating create SQL for: ^1..^2     key constraint:   ^3   compressed extents: ^4
set termout off
select 
initcap('prompt Creating'||decode(constraint_type,'P',' PRIMARY KEY ','U',' UNIQUE ',' ')||'constraint on Table: ')||upper('^2')||'   Constraint: '||'^3' buff,
'ALTER TABLE '||upper('^2')||' ADD CONSTRAINT '||upper('^3')||decode(constraint_type,'P',' PRIMARY KEY ','U',' UNIQUE ',' ')||'('
 from dba_constraints
where constraint_name = upper('^3')
  and table_name = upper('^2')
  and owner = upper('^1');
select
'       '||rpad(column_name,35,' ')||decode(position,^max_position,')',',')
from dba_cons_columns 
where table_name = upper('^2')
  and constraint_name = upper('^3')
  and owner = upper('^1')
order by position;
select ';' buff,
'REM Warning! Constraint ^1..^3 has an index with another name to enforce uniqueness!' buff
from  dual
where not exists (select index_name
from dba_indexes dbi,
     dba_constraints dbc
where dbi.table_name = upper('^2')
  and dbc.constraint_name = upper('^3')
  and dbi.index_name = upper('^3')
  and dbi.table_owner = upper('^1')
  and dbc.owner = upper('^1')
  and dbc.table_name = upper('^2'));


select
'USING INDEX ' buff,
decode(NVL(pct_free,-1),-1,'','       PCTFREE '||pct_free) buff,
decode(NVL(ini_trans,-1),-1,'','      INITRANS '||ini_trans) buff,
decode(NVL(max_trans,-1),-1,'','      MAXTRANS '||max_trans) buff,
'      TABLESPACE '||dbi.tablespace_name buff,
'STORAGE (' buff,
'         INITIAL '||decode('^4','Y',^tot_bytes||' K','y',^tot_bytes||' K',initial_extent/1024||' K') buff,
decode(NVL(next_extent,-1),-1,'','          NEXT '||next_extent) buff,
decode(NVL(next_extent,-1),-1,'','          PCTINCREASE '||pct_increase) buff,
decode(NVL(min_extents,-1),-1,'','          MINEXTENTS '||min_extents) buff,
decode(NVL(max_extents,-1),-1,'','          MAXEXTENTS '||max_extents) buff,
'        )'||decode(dbc.status,'DISABLED',' DISABLE;','ENABLED',';') buff
from dba_indexes dbi,
     dba_constraints dbc
where dbi.table_name = upper('^2')
  and dbc.constraint_name = upper('^3')
  and dbi.index_name = upper('^3')
  and dbi.table_owner = upper('^1')
  and dbc.owner = upper('^1')
  and dbc.table_name = upper('^2');
