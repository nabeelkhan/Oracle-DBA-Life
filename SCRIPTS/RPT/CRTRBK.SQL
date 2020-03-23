REM crtrbk.sql checked out on 10/18/97 17:05:12 version 1.5
set heading off
set verify off
set embedded on
set pagesize 0
set arraysize 2
set space 0
set wrap off
set define '^'

set termout on
prompt REM Generating create SQL for rollback segment: ^1..^2    in tablespace: ^3    compress: ^4
set termout off


select 
'CREATE '||decode(nvl(instance_num,'-1'),'-1','','PUBLIC ')||'ROLLBACK SEGMENT '||upper('^2')||' TABLESPACE '||upper('^3')
from dba_rollback_segs
where owner = upper('^1')
  and segment_name = upper('^2')
  and tablespace_name = upper('^3');
select 
'       STORAGE (' buff,
decode(NVL(initial_extent,-1),-1,'', '                        INITIAL '||initial_extent) buff,
decode(NVL(next_extent,-1),-1,'','                        NEXT '||next_extent) buff,
'                        MINEXTENTS '||min_extents buff,
'                        MAXEXTENTS '||max_extents buff,
decode(optsize, NULL, '','                        OPTIMAL    '||optsize) buff,
'                       );' buff
from dba_rollback_segs rs,
     v$rollstat rstat
where owner = upper('^1')
  and segment_name = upper('^2')
  and tablespace_name = upper('^3')
  and rs.segment_id = rstat.usn (+);
