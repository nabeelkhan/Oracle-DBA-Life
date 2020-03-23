set echo on
set linesize 121

clear screen
create or replace function f( x in varchar2 ) return number
as
begin	
	dbms_application_info.set_client_info(userenv('client_info')+1 );
	return length(x);
end;
/
pause

clear screen
exec dbms_application_info.set_client_info(0);
set autotrace traceonly statistics;
select owner, f(owner) from all_objects;
set autotrace off
select userenv('client_info') from dual;
pause



clear screen
exec dbms_application_info.set_client_info(0);
set autotrace traceonly statistics;
select owner, (select f(owner) from dual) f from all_objects;
set autotrace off
select userenv('client_info') from dual;
pause


clear screen
exec dbms_application_info.set_client_info(0);
set autotrace traceonly statistics;
select owner, (select f(owner) from dual) f 
  from (select owner from all_objects order by owner);
set autotrace off
select userenv('client_info') from dual;
pause
