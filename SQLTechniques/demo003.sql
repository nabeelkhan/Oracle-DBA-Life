@connect scott/tiger

set echo on
break on deptno skip 1
set pause on
clear screen
select deptno, ename, sal, rn
  from (
Select deptno, ename, sal, 
       row_number() over (partition by deptno order by sal desc) rn
  from emp 
       )
 where rn <= 3
/
pause
clear screen

select deptno, ename, sal, rank
  from (
Select deptno, ename, sal, 
       rank() over (partition by deptno order by sal desc) rank
  from emp 
       )
 where rank <= 3
/
pause
clear screen

select deptno, ename, sal, dr
  from (
Select deptno, ename, sal, 
       dense_rank() over (partition by deptno order by sal desc) dr
  from emp 
       )
 where dr <= 3
/
set pause off
