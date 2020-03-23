set echo on
set linesize 121
clear screen
delete from plan_table;
explain plan for
select * from (select * from scott.emp order by sal desc) where rownum <= 10;
pause
clear screen
select * from table(dbms_xplan.display);
pause


clear screen
delete from plan_table;
explain plan for
select * from scott.emp order by sal desc;
pause

clear screen
select * from table(dbms_xplan.display);
pause


clear screeen
@trace
set autotrace traceonly statistics
select * from (select * from all_objects order by object_id) where rownum <= 10;
set autotrace off
pause
clear screen
declare
   cursor c is 
      select * from all_objects order by object_id;
   l_rec all_objects%rowtype;
begin
   open c;
   for i in 1 .. 10
   loop
       fetch c into l_rec;
   end loop;
   close c;
end;
/
pause
select * from dual;
disconnect 
connect /
!tkprof `ls -t $ORACLE_HOME/admin/$ORACLE_SID/udump/*ora_*.trc | head -1` ./tk.prf sys=no 
edit tk.prf
