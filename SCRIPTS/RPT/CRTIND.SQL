REM crtind.sql checked out on 10/20/97 17:05:12 version 1.11
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

select max(column_position) max_column_position
from all_ind_columns
where table_name = upper('^2')
  and index_name = upper('^3')
  and table_owner = upper('^1');

select nvl(sum(bytes)/1024,0) sum_bytes
from dba_extents
where segment_name = upper('^3')
  and owner in (select owner
		  from all_indexes
		  where table_name = upper('^2')
		    and index_name = upper('^3')
		    and table_owner = upper('^1')
	    	 );

set termout on
prompt REM Generating create SQL for: ^1..^2     index:   ^3   compressed extents: ^4 stats: ^5  parallel: ^6
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
  and table_owner = upper('^1')
order by column_position;

select 
decode(NVL(ini_trans,-1),-1,'','      INITRANS '||ini_trans) buff,
decode(NVL(max_trans,-1),-1,'','      MAXTRANS '||max_trans) buff,
'      TABLESPACE '||di.tablespace_name||'  PARALLEL ^6' buff,
'STORAGE (' buff,
'         INITIAL '||decode('^4','Y',^tot_bytes||' K','y',^tot_bytes||' K',initial_extent/1024||' K') buff,
decode(NVL(next_extent,-1),-1,'','          NEXT '||next_extent) buff,
decode(NVL(next_extent,-1),-1,'','          PCTINCREASE '||pct_increase) buff,
decode(NVL(min_extents,-1),-1,'','          MINEXTENTS '||min_extents) buff,
decode(NVL(max_extents,-1),-1,'','          MAXEXTENTS '||max_extents) buff,
'        )' buff,
decode(NVL(pct_free,-1),-1,';','      PCTFREE '||pct_free||';') buff,
decode(upper('^5'),'Y','analyze index ^3 compute statistics;') buff
from all_indexes di
where di.table_name = upper('^2')
  and index_name = upper('^3')
  and di.table_owner = upper('^1')
;
