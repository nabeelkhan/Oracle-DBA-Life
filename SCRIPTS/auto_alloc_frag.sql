spool c:\for_oracle-l.txt
set echo on
select banner from v$version;

create tablespace auto_alloc_test
datafile 'c:\temp\auto_alloc.dbf' size 32832k
extent management local;

/*
create the tables
*/

begin
for i in 1..32 loop
execute immediate 'create table table'||i||'(col1 number,col2 number) tablespace auto_alloc_test';
end loop;
end;
/

select sum(bytes)/1024 free_k from dba_free_space where tablespace_name='AUTO_ALLOC_TEST';

begin
for i in 1..15 loop
	for j in 1..32 loop
		execute immediate 'alter table table'||j||' allocate extent';
	end loop;
end loop;
end;
/

select sum(bytes)/1024/1024 free_M from dba_free_space where tablespace_name='AUTO_ALLOC_TEST';

begin
for i in 1..32 loop
	if i mod 2 = 0 then
		execute immediate 'drop table table'||i;
	end if;
end loop;
end;
/

select sum(bytes)/1024/1024 free_mb from dba_free_space where tablespace_name='AUTO_ALLOC_TEST';

alter table table1 allocate extent;

drop tablespace auto_alloc_test including contents and datafiles;

spool off

