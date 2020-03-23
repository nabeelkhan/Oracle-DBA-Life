@connect scott/tiger

set echo on
break on deptno skip 1
set pause on
clear screen
Select deptno, ename, sal, 
       rank() over ( partition by deptno order by sal desc ) r,
       dense_rank() over ( partition by deptno order by sal desc ) dr,
       row_number() over ( partition by deptno order by sal desc ) rn
  from emp 
 order by deptno, sal desc;
set pause off
