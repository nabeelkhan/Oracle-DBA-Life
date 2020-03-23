@connect /
set echo on
clear screen

drop table emp;
create table emp as select * from scott.emp;
pause
clear screen
set pause on

select deptno,
       count(*),
       percentile_cont(0.5) within group (order by sal) med
  from emp
 group by deptno
/
pause
clear screen

select deptno,
       sal,
       cnt,
       rn,
       case when
           ((mod(cnt,2) = 1 and rn = ceil(cnt/2) )
            or (mod(cnt,2) = 0 and rn in ( cnt/2, cnt/2+1 ) )) then '<<===='
        end
  from (
select deptno,
       sal,
       count(*) over (partition by deptno) cnt,
       row_number() over(partition by deptno order by sal) rn
  from emp
       )
/
pause
clear screen
select deptno,
       sal,
       cnt,
       rn
  from (
select deptno,
       sal,
       count(*) over (partition by deptno) cnt,
       row_number() over(partition by deptno order by sal) rn
  from emp
       )
 where (mod(cnt,2) = 1 and rn = ceil(cnt/2) )
    or (mod(cnt,2) = 0 and rn in ( cnt/2, cnt/2+1 ) )
/
pause
clear screen

select deptno,
       avg(sal),
       cnt
  from (
select deptno,
       sal,
       count(*) over (partition by deptno) cnt,
       row_number() over(partition by deptno order by sal) rn
  from emp
       )
 where (mod(cnt,2) = 1 and rn = ceil(cnt/2) )
    or (mod(cnt,2) = 0 and rn in ( cnt/2, cnt/2+1 ) )
 group by deptno, cnt
/
pause
clear screen

SELECT deptno, AVG(DISTINCT sal)
  FROM  (SELECT cp1.deptno, CP1.sal
           FROM emp CP1, emp CP2
          where cp1.deptno = cp2.deptno
          GROUP BY cp1.deptno, CP1.sal
         HAVING SUM(DECODE(CP1.sal, CP2.sal, 1, 0)) >=
                        ABS(SUM(SIGN(CP1.sal - CP2.sal))))
 group by deptno
/

pause
clear screen

insert into emp select * from emp;
insert into emp select * from emp;
insert into emp select * from emp;
insert into emp select * from emp;
insert into emp select * from emp;
insert into emp select * from emp;
insert into emp select * from emp;
insert into emp select * from emp;
commit;
exec dbms_stats.gather_table_stats(user,'EMP');
select count(*) from emp;
pause
clear screen
set pause off

@trace
select deptno,
       count(*),
       percentile_cont(0.5) within group (order by sal) med
  from emp
 group by deptno
/
pause
clear screen

select deptno,
       avg(sal),
       cnt
  from (
select deptno,
       sal,
       count(*) over (partition by deptno) cnt,
       row_number() over(partition by deptno order by sal) rn
  from emp
       )
 where (mod(cnt,2) = 1 and rn = ceil(cnt/2) )
    or (mod(cnt,2) = 0 and rn in ( cnt/2, cnt/2+1 ) )
 group by deptno, cnt
/
pause
clear screen

SELECT deptno, AVG(DISTINCT sal)
  FROM  (SELECT cp1.deptno, CP1.sal
           FROM emp CP1, emp CP2
          where cp1.deptno = cp2.deptno
          GROUP BY cp1.deptno, CP1.sal
         HAVING SUM(DECODE(CP1.sal, CP2.sal, 1, 0)) >=
                        ABS(SUM(SIGN(CP1.sal - CP2.sal))))
 group by deptno
/

@connect scott/tiger
!tk

