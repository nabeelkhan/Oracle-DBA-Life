REM crttab.sql checked out on 12/14/97 17:05:12 version 1.12
set heading off
set verify off
set embedded on
set pagesize 0
set arraysize 2
set long 9999
set space 0
set wrap off
set define '^'
column data_default format a30 word_wrapped
column max_column_id new_value max_id noprint;
column sum_bytes new_value tot_bytes noprint;

select max(column_id) max_column_id
from all_tab_columns
where table_name = upper('^2')
and   owner = upper('^1');

select sum(bytes)/1024 sum_bytes
from dba_extents
where segment_name = upper('^2')
  and owner = upper('^1');

set termout on
prompt REM Generating create SQL for: ^1..^2     compressed extents: ^3 stats: ^4
set termout off

select 
'PROMPT Creating table ^1..^2' buff,
'CREATE TABLE "'||upper('^1')||'"."'||upper('^2')||'"('
 from dual;

select
'       '||rpad('"'||column_name||'"',35,' ')||rpad(data_type,8,' ')||
decode(data_type,'NUMBER',decode(nvl(data_precision,-1),'-1',decode(nvl(data_scale,-1),'-1','','(38'),'('||data_precision), 
'DATE','', 'LONG','', 'DATE','','LONG RAW','' ,'MLSLABEL','','ROWID','','('||data_length)||
decode(data_type,'NUMBER', decode(nvl(data_scale,-1), '-1','', ','||data_scale||')') ,'DATE','','LONG','', 
'LONG RAW','', 'MLSLABEL','','ROWID','',')')||decode(nullable,'Y','','N','  NOT NULL')||
decode(column_id,^max_id,')',',')
from all_tab_columns 
where table_name = upper('^2')
and   owner = upper('^1')
order by column_id;

rem order by nullable asc,column_id;


select 
decode(NVL(pct_free,-1),-1,'','      PCTFREE '||pct_free) buff,
decode(NVL(pct_used,-1),-1,'','      PCTUSED '||pct_used) buff,
decode(NVL(ini_trans,-1),-1,'','      INITRANS '||ini_trans) buff,
decode(NVL(max_trans,-1),-1,'','      MAXTRANS '||max_trans) buff,
'      TABLESPACE "'||dt.tablespace_name||'"' buff,
'STORAGE (' buff,
'         INITIAL '||decode('^3','Y',^tot_bytes||' K','y',^tot_bytes||' K',initial_extent/1024||' K') buff,
decode(NVL(next_extent,-1),-1,'','         NEXT '||next_extent/1024||' K') buff,
decode(NVL(pct_increase,-1),-1,'','         PCTINCREASE '||pct_increase) buff,
decode(NVL(min_extents,-1),-1,'','          MINEXTENTS '||min_extents) buff,
decode(NVL(max_extents,-1),-1,'','          MAXEXTENTS '||max_extents) buff,
'        ) '||decode(replace(cache,' '),'Y','CACHE',' ')||decode(replace(degree,' '),'1',' ',' PARLLEL ( DEGREE '||replace(degree,' ')||' INSTANCES '||replace(instances,' ')||')')||';' buff
from all_tables dt
where table_name = upper('^2')
  and dt.owner = upper('^1')
;
select
'COMMENT ON TABLE '||owner||'.'||table_name||' IS ' buff,
''''||comments||''';'
from all_tab_comments
where table_name = upper('^2')
  and owner = upper('^1')
  and comments is not null
union
select
'COMMENT ON COLUMN '||owner||'.'||table_name||'.'||column_name||' IS ' buff,
''''||comments||''';'
from all_col_comments
where table_name = upper('^2')
  and owner = upper('^1')
  and comments is not null
;
set wrap on
select
'Alter table '||owner||'.'||table_name||' MODIFY '||column_name||' DEFAULT ', data_default,';'
from all_tab_columns
where table_name = upper('^2')
  and owner = upper('^1')
    and data_default is not null;
select
decode(upper('^4'),'Y','analyze table ^2 compute statistics;') buff
from dual;
