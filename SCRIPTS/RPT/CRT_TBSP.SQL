REM crt_tbsp.sql checked out on 9/22/97 17:05:12 version 1.4
set heading off
set verify off
set embedded on
set pagesize 0
set arraysize 2
set space 0
set wrap off
column max_file_id new_value max_id noprint;
column max_name_len new_value max_len noprint;

select max(file_id) max_file_id,max(length(file_name))+2 max_name_len
from dba_data_files
where tablespace_name = upper('&1');

set termout on
prompt REM Generating create SQL for tablespace: &1
set termout off


select 
'CREATE TABLESPACE '||upper('&1') buff,
'       DATAFILE' buff
 from dual;

select
'       '''||rpad(file_name||'''',&max_len,' ')||'SIZE '||bytes||decode(file_id,&max_id,'',',')
from dba_data_files 
where tablespace_name = upper('&1')
order by file_id;

select 
'       DEFAULT STORAGE (' buff,
decode(NVL(initial_extent,-1),-1,'', '                        INITIAL '||initial_extent) buff,
decode(NVL(next_extent,-1),-1,'','                        NEXT '||next_extent) buff,
'                        MINEXTENTS '||min_extents buff,
'                        MAXEXTENTS '||max_extents buff,
'                        PCTINCREASE '||pct_increase buff,
'                       )' buff,
'      '||decode(status,'OFFLINE','OFFLINE','ONLINE')||';' buff
from dba_tablespaces
where tablespace_name = upper('&1');
select
'ALTER TABLESPACE '||tablespace_name||' READ ONLY;' buff
from dba_tablespaces
where tablespace_name = upper('&1')
  and status = 'READ ONLY';
