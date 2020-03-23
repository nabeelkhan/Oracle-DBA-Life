set echo on
set linesize 121
clear screen
@trace
set autotrace traceonly statistics
variable max number
variable min number
exec :min := 100; :max := 115;
pause
select * 
  from (select /*+ FIRST_ROWS */ a.*, rownum rnum
          from (select * from all_objects order by object_id) a
         where rownum <= :Max) 
 where rnum >= :min;
set autotrace off
pause



clear screen
declare
   cursor c is 
      select * from all_objects order by object_id;
   l_rec all_objects%rowtype;
begin
   open c;
   for i in 1 .. 115
   loop
       fetch c into l_rec;
       if ( i < 100 )
       then
           null;
       else
        null; -- process it
       end if;
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
