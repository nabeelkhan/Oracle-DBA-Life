REM crtcpr.sql checked out on 3/27/96 17:05:12 version 1.3
set heading off
set verify off
set embedded on
set pagesize 0
set arraysize 2
set space 0
set wrap off
set define '^'
column min_priv_text new_value min_priv noprint;

select min(table_name||column_name||privilege) min_priv_text
from dba_tab_privs
where grantor = upper('^1')
  and grantee = upper('^2')
  and table_name like upper('^3');

set termout on
prompt REM Processing Table Grants SQL grantor: ^1    grantee: ^2   table names like: ^3
set termout off

select 
decode(table_name||column_name||privilege,'^min_priv','connect ^1/&&orapass_^1') buff,
'grant '||privilege||' on "'||owner||'"."'||table_name||'"."'||column_name||'" to '||grantee||decode(grantable,'YES',' with grant option;',';') buff
from dba_col_privs 
where table_name like upper('^3')
and   grantor = upper('^1')
and   grantee = upper('^2')
order by table_name;
