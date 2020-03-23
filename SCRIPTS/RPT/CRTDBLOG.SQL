REM crtdblog.sql checked out on 3/27/96 17:05:17 version 1.3
set define '^'
column max_member new_value max_name noprint;
column max_name_len new_value max_len noprint;
column bytes new_value grp_bytes noprint;
select max(vlf.member) max_member, max(length(vlf.member))+2 max_name_len,vl.bytes
from v$logfile vlf, 
     v$log vl
where vlf.group# = ^1
  and vl.group# = ^1
group by vl.bytes;
select 
'	GROUP ^1 ('
from dual;
select
'       '''||rpad(member||'''',^max_len,' ')||decode(member,'^max_name',') SIZE '||^grp_bytes)||','
from v$logfile
where group# = ^1
order by member;
