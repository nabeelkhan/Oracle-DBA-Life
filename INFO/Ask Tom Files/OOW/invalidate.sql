drop table t1;
drop table t2;

create table t1 ( x int );
insert into t1 values ( 1 );

create table t2 ( x int, y int );
insert into t2 values ( 2, 2 );

create or replace synonym t for t1;

create or replace procedure p
as
begin
	for c in (select * from t) loop dbms_output.put_line( c.x ); end loop;
end;
/
create or replace view v
as
select x from t
/

@invalid
select * from t;
exec p
create or replace synonym t for t2;
@invalid
select * from t;
exec p
