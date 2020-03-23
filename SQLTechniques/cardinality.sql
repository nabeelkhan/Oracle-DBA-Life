@connect /

set linesize 121
set echo on
drop table emp;

clear screen
create or replace type str2tblType as table of varchar2(30);
/
create or replace 
function str2tbl( p_str in varchar2, p_delim in varchar2 default ',' ) 
return str2tblType
PIPELINED
as
    l_str      long default p_str || p_delim;
    l_n        number;
begin
    loop
        l_n := instr( l_str, p_delim );
        exit when (nvl(l_n,0) = 0);
		pipe row ( ltrim(rtrim(substr(l_str,1,l_n-1))) );
        l_str := substr( l_str, l_n+1 );
    end loop;
    return;
end;
/
pause

clear screen
variable str varchar2(50);
exec :str := '1,2,3,4';
select * from table( cast( str2tbl(:str) as str2tblType ) );
pause

clear screen
create table emp
as
select * 
  from (
select object_name ename, max(object_id) empno, 
       max(object_type) ot, max(created) created
  from all_objects
 group by object_name
       )
 where rownum <= 5000;
alter table emp add constraint emp_pk primary key(empno);
create index ename_idx on emp(ename);
exec dbms_stats.gather_table_stats( user, 'EMP', cascade=>true );
pause

clear screen
variable in_list varchar2(255)
exec :in_list := 'DBMS_PIPE,DBMS_OUTPUT,UTL_FILE';
set autotrace traceonly explain
select * 
  from TABLE(cast( str2tbl( :in_list ) as str2tblType) ) t;
pause
clear screen
select /*+ cardinality( 10 ) */ *
  from TABLE(cast( str2tbl( :in_list ) as str2tblType) ) t;
set autotrace traceonly 
pause

clear screen
set autotrace traceonly explain
with T
as
( select * 
    from TABLE(cast( str2tbl( :in_list ) as str2tblType) ) t where rownum > 0
)
select *
  from emp
 where ename in ( select * from t )
/
pause

clear screen
with T
as
( select * 
    from TABLE(cast( str2tbl( :in_list ) as str2tblType) ) t where rownum > 0
)
select *
  from emp
 where ename in ( select /*+ cardinality(10) */ * from t )
/
set autotrace off
