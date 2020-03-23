REM crtdbl.sql checked out on 8/15/97 17:05:12 version 1.5
set heading off
set verify off
set embedded on
set pagesize 0
set arraysize 2
set space 0
set wrap off
set define '^'
column min_dbl_text new_value min_text noprint;
column temp_userid_text new_value userid_text noprint;
column temp_host_text new_value host_text noprint;

select 
decode('^link_userid', '%', '(l.userid like upper(''^link_userid'') or l.userid is null)', 'l.userid = ''^link_userid''') temp_userid_text,
decode('^host_id', '%', '(l.host like upper(''^host_id'') or l.host is null)', 'l.host = ''^host_id''') temp_host_text
from dual;


select min(u.name||l.name) min_dbl_text
from sys.link$ l, sys.user$ u
where l.owner# = u.user#
  and u.name = upper('^1')
  and l.name like upper('^link_name')
  and ^userid_text
  and ^host_text
  ;

set termout on
prompt REM Processing Database links SQL for owner: ^1    link: ^2   
set termout off

select 
decode(u.name||l.name,'^min_text','connect '||decode('^1','PUBLIC','SYSTEM','^1')||'/&&orapass_'||decode('^1','PUBLIC','SYSTEM','^1')) buff,
'create '||decode(u.name,'PUBLIC','PUBLIC')||' database link '||decode(u.name,'PUBLIC','')||l.name||
decode(l.userid,NULL,NULL,' CONNECT TO '||l.userid||' IDENTIFIED BY '||l.password)||' USING '''||l.host||''';' buff
from sys.link$ l, sys.user$ u 
where l.owner# = u.user#
and   u.name = upper('^1')
and   l.name = upper('^2')
order by l.name;
