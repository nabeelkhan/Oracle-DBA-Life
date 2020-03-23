REM crtsyn.sql checked out on 3/27/96 17:05:12 version 1.3
set heading off
set verify off
set embedded on
set pagesize 0
set arraysize 2
set space 0
set wrap off
set define '^'
column min_syn_text new_value min_text noprint;

select min(owner||synonym_name) min_syn_text
from all_synonyms
where owner = upper('^1')
  and synonym_name like upper('^syn_name')
  and table_owner like upper('^tab_owner')
  and table_name like upper('^tab_prefix');

set termout on
prompt REM Processing Synonyms SQL owner: ^1    synonym: ^2   
set termout off

select 
decode(owner||synonym_name,'^min_text','connect '||decode('^1','PUBLIC','SYSTEM','^1')||'/&&orapass_'||decode('^1','PUBLIC','SYSTEM','^1')) buff,
'create '||decode(owner,'PUBLIC','PUBLIC')||' synonym '||decode(owner,'PUBLIC','','"'||owner||'".')||'"'||table_name||'" for "'||table_owner||'"."'||table_name||'"'||decode(db_link,NULL,';','@'||db_link||';') buff
from all_synonyms 
where owner = upper('^1')
and   synonym_name = upper('^2')
order by synonym_name;
