REM crtindp.sql checked out on 10/20/97 17:05:17 version 1.9
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
column proj_bytes new_value new_bytes noprint;
column sum_bytes new_value tot_bytes noprint;
column bytes_used new_value bused noprint;
column type_used new_value tused noprint;

select max(column_position) max_column_position
from all_ind_columns
where table_name = upper('^2')
  and index_name = upper('^3')
  and table_owner = upper('^1');



select round(^blocksize/1024 * 1.05 * tct.proj_count * (^ind_entry_header + ^ind_rowid_length + (1 * tci.num_leq_250) + 
       (3 * tci.num_gt_250) + tci.row_length+ decode(dbi.UNIQUENESS,'NONUNIQUE',^ind_rowid_length,0) )/
       (floor((^blocksize - ^ind_fixed_header - (^ind_variable_header * INI_TRANS))/(^ind_entry_header + ^ind_rowid_length + 
       (1 * tci.num_leq_250) + (3 * tci.num_gt_250) + tci.row_length+ decode(dbi.UNIQUENESS,'NONUNIQUE',^ind_rowid_length,0))) * 
       (^ind_entry_header + ^ind_rowid_length + (1 * tci.num_leq_250) + (3 * tci.num_gt_250) + tci.row_length+ 
       decode(dbi.UNIQUENESS,'NONUNIQUE',^ind_rowid_length,0) ))) proj_bytes
from
     table_counts tci,
     table_counts tct,
     all_indexes dbi
where tct.table_owner like upper('^1')
  and tct.table_name like upper('^2')
  and dbi.table_name = tct.table_name
  and dbi.index_name = tci.table_name
  and tci.table_name = upper('^3')
  and tci.table_owner = tct.table_owner;

select sum(bytes)/1024 sum_bytes
from dba_extents
where segment_name = upper('^3')
  and owner = upper('^1');

select decode('^new_bytes',0,'^tot_bytes','','^tot_bytes',greatest(2*^blocksize/1024,^new_bytes)) bytes_used,
       lpad(decode('^new_bytes',0,'Current Size:','','Current Size:','Projected/Min Size:'),18,' ') type_used
from dual;

set termout on
prompt REM Generating create SQL for: ^1..^2     index:   ^3   ^tused ^bused Kb Stats: ^4  Parallel: ^5
set termout off

select 
'PROMPT Dropping index ^1..^3 on ^2' buff,
'DROP INDEX '||upper('^3')||';' buff,
'PROMPT Creating '||decode(uniqueness,'Y','Unique index ','UNIQUE',uniqueness||' Index ','Index ')||'^1..^3 on ^2' buff,
'CREATE '||decode(uniqueness,'Y','UNIQUE INDEX ','UNIQUE',uniqueness||' INDEX ','INDEX ')||upper('^3')||' on '||upper('^2')||'('
 from all_indexes
where index_name = upper('^3')
  and table_name = upper('^2')
  and table_owner = upper('^1');

select
'       '||rpad(column_name,35,' ')||decode(column_position,^max_position,')',',')
from all_ind_columns 
where table_name = upper('^2')
  and index_name = upper('^3')
  and index_owner = upper('^1')
order by column_position;

select 
decode(NVL(ini_trans,-1),-1,'','      INITRANS '||ini_trans) buff,
decode(NVL(max_trans,-1),-1,'','      MAXTRANS '||max_trans) buff,
'      TABLESPACE '||di.tablespace_name||''  '||decode(^5,1,NULL,'PARALLEL '||^5) buff,
'STORAGE (' buff,
'         INITIAL ^bused K' buff,
decode(NVL(next_extent,-1),-1,'','          NEXT '||next_extent) buff,
decode(NVL(next_extent,-1),-1,'','          PCTINCREASE '||pct_increase) buff,
decode(NVL(min_extents,-1),-1,'','          MINEXTENTS '||min_extents) buff,
decode(NVL(max_extents,-1),-1,'','          MAXEXTENTS '||max_extents) buff,
'        )' buff,
decode(NVL(pct_free,-1),-1,';','      PCTFREE '||pct_free||';') buff,
decode(upper('^4'),'Y','analyze index ^3 compute statistics;') buff
from all_indexes di
where di.table_name = upper('^2')
  and index_name = upper('^3')
  and di.table_owner = upper('^1')
;
