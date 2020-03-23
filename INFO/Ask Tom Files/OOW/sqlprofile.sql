set echo on
spool sqlprofile

drop table sqlprof;

create table sqlprof 
as 
select * from all_objects;

alter table sqlprof add constraint sqlprof_pk primary key(object_id);

exec dbms_stats.gather_table_stats( user, 'SQLPROF', cascade=>true );

create or replace procedure p
as
	cursor c1 
	is 
	select object_id, object_name 
	  from sqlprof 
	 order by object_id;

	l_object_id   sqlprof.object_id%type;
	l_object_name sqlprof.object_name%type;
begin
	open c1;
	for i in 1 .. 10 
	loop	
		fetch c1 into l_object_id, l_object_name;
		exit when c1%notfound;
		-- .... 
	end loop;
end;
/


exec p

begin
	for i in 1 .. 1000
	loop
		p;
	end loop;
end;
/

declare
	l_sql_id v$sql.sql_id%type;
begin
	select sql_id  into l_sql_id
      from v$sql 
	 where sql_text = 'SELECT OBJECT_ID, OBJECT_NAME FROM SQLPROF ORDER BY OBJECT_ID';
	dbms_output.put_line( 
	sys.dbms_sqltune.create_tuning_task
	( sql_id    => l_sql_id,
      task_name => 'sqlprof_query' ) || ' in place...' );
end;
/
			
exec dbms_sqltune.execute_tuning_task( task_name => 'sqlprof_query' );

SELECT status FROM DBA_ADVISOR_LOG WHERE task_name = 'sqlprof_query';

SET LONG 100000
SET LINESIZE 100
SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK( 'sqlprof_query')
  FROM DUAL;

exec dbms_sqltune.drop_tuning_task( 'sqlprof_query' );
spool off
