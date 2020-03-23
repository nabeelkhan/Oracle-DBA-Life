set echo on
set linesize 121
clear screen
create or replace function f(x in number) return number
as
begin
    dbms_application_info.set_client_info(userenv('client_info')+1);
    return 42;
end;
/
pause

clear screen
exec dbms_application_info.set_client_info(0);
set pause on
select emp.empno, f(dept.deptno)
  from scott.emp, scott.dept
 where emp.deptno = dept.deptno;
pause
set pause off
clear screen
select userenv('client_info') from dual;
pause


clear screen
exec dbms_application_info.set_client_info(0);
set pause on
select emp.empno, fdeptno, dname
  from scott.emp, 
       (select deptno, f(deptno) fdeptno, dname from scott.dept )dept
 where emp.deptno = dept.deptno;
pause
set pause off
clear screen
select userenv('client_info') from dual;
pause

clear screen
exec dbms_application_info.set_client_info(0);
set pause on
select emp.empno, fdeptno, dname
  from scott.emp, 
       (select deptno, f(deptno) fdeptno, dname, rownum r from scott.dept )dept
 where emp.deptno = dept.deptno;
pause
set pause off
clear screen
select userenv('client_info') from dual;
pause

alter session set optimizer_goal=first_rows;

clear screen
exec dbms_application_info.set_client_info(0);
set pause on
select emp.empno, fdeptno, dname
  from scott.emp, 
       (select /*+ NO_MERGE */ deptno, dname, f(deptno) fdeptno from scott.dept )dept
 where emp.deptno = dept.deptno;
pause
set pause off
clear screen
select userenv('client_info') from dual;
pause

clear screen
delete from plan_table;
explain plan for
select emp.empno, fdeptno, dname
  from scott.emp, 
       (select deptno, f(deptno) fdeptno, dname, rownum r from scott.dept )dept
 where emp.deptno = dept.deptno;
pause


clear screen
select * from table(dbms_xplan.display);
pause



clear screen
delete from plan_table;
explain plan for
select emp.empno, fdeptno, dname
  from scott.emp, 
       (select /*+ NO_MERGE */ deptno, dname, f(deptno) fdeptno from scott.dept )dept
 where emp.deptno = dept.deptno;
pause


clear screen
select * from table(dbms_xplan.display);
pause
