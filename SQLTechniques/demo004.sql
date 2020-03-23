@connect scott/tiger
column last_5 format a30
set echo on
set pause on
clear screen
Select ename, sal, 
       round( 
	     avg(sal) over (order by sal 
                             rows 5 preceding)
		 ) avg_sal,
       rtrim(
       lag(sal) over (order by sal) || ',' ||
       lag(sal,2) over (order by sal) || ',' ||
       lag(sal,3) over (order by sal) || ',' ||
       lag(sal,4) over (order by sal) || ',' ||
       lag(sal,5) over (order by sal),',') last_5
  from emp 
 order by sal;
set pause off
pause
select round( (3000+3000+2975+2850+2450+5000)/6 ) from dual
/
