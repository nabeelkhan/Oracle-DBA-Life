@connect scott/tiger

set echo on
break on deptno skip 1
set pause on
clear screen
Select deptno, ename, sal, 
       sum(sal) over (partition by deptno order by sal) running_total1,
       sum(sal) over (partition by deptno order by sal, rowid) running_total2
  from emp order by deptno, sal;
set pause off
