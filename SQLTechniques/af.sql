set echo on
alter session set sql_trace=true;

begin
    for x in ( select /* this is my very nice Comment */ * 
                 from big_table.big_table 
                where rownum <= 10000 ) 
    loop
        null;
    end loop;
end;
/
pause
connect /
!tk
drop table t;
create table t ( x int );
begin
    savepoint foo;

    insert into t 
    select 1 
      from all_objects 
     where rownum <= 1;

    for x in ( select * from t )
    loop
        rollback to savepoint foo;
    end loop;
end;
/
pause

begin
    savepoint foo;

    insert into t 
    select 1 
      from all_objects 
     where rownum <= 101;
	 
    for x in ( select * from t )
    loop
        rollback to savepoint foo;
    end loop;
end;
/
