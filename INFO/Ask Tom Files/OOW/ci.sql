@connect /
set echo on
set linesize 121
drop table t;
clear screen
create table t ( data varchar2(20) );
insert into t values ( 'Hello' );
insert into t values ( 'HeLlO' );
insert into t values ( 'HELLO' );
create index t_idx on 
t( nlssort( data, 'NLS_SORT=BINARY_CI' ) );
pause

clear scr
variable x varchar2(25)
exec :x := 'hello';

select * from t where data = :x;
pause

clear scr
alter session set nls_comp=ansi;
alter session set nls_sort=binary_ci;
select * from t where data = :x;
pause

clear scr
set autotrace traceonly explain 
select /*+ first_rows */ * from t where data = :x;
set autotrace off
