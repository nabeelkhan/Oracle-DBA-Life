@connect scott/tiger

break on deptno skip 1
set pause on
clear screen
select deptno, ename, sal, 
       to_char( round( 
	     ratio_to_report(sal) over (partition by deptno)
		 *100, 2 ), '990.00' )||'%' rtr
  from emp
/
set pause off
