
@connect /
set echo on
clear screen

drop table t;

create table t ( x date, y int );
pause
clear screen
 
declare
        l_date date := to_date( '12:22:03', 'hh24:mi:ss' );
begin
        for i in 1 .. 10
        loop
             insert into t values ( l_date, dbms_random.value( 0, 100 ) );
             l_date := l_date + 1/24/60/60;
        end loop;
        l_date := l_date + 5/24/60/60;
        for i in 1 .. 3
        loop
             insert into t values ( l_date, dbms_random.value( 0, 100 ) );
             l_date := l_date + 1/24/60/60;
        end loop;
        l_date := l_date + 15/24/60/60;
        for i in 1 .. 12
        loop
             insert into t values ( l_date, dbms_random.value( 0, 100 ) );
             l_date := l_date + 1/24/60/60;
        end loop;
end;
/
pause
clear screen
alter session set nls_date_format = 'hh24:mi:ss';

set pause on

select x, y, 
       lag(x) over (order by x),
       case 
          when abs(lag(x) over (order by x) - x) > 3/24/60/60 
               then row_number() over (order by x)
       end rn
  from t
/
pause 
clear screen
select x, y, 
       max(rn) over (order by x) max_rn
  from (
select x, y, 
       lag(x) over (order by x),
       case 
          when abs(lag(x) over (order by x) - x) > 3/24/60/60 
               then row_number() over (order by x)
       end rn
  from t
       )
/
pause
clear screen

select min(x), max(x), sum(y) 
  from (
select x, y, 
       max(rn) over (order by x) max_rn
  from (
select x, y, 
       lag(x) over (order by x),
       case 
          when abs(lag(x) over (order by x) - x) > 3/24/60/60 
               then row_number() over (order by x)
       end rn
  from t
       )
       )
 group by max_rn
 order by 1
/
set pause off
