@connect /
set echo on

set termout off
alter session set query_rewrite_enabled = true;
alter session set query_rewrite_integrity = trusted;
drop table t;
set termout on
set feedback off
clear screen
create table t ( x int not null, y int not null, z int );
insert into t values ( 1, 4, 55 );
insert into t values ( 1, 4, 55 );
insert into t values ( 2, 3, 42 );
insert into t values ( 2, 3, 42 );
pause
set feedback on
set linesize 121

clear screen
set autotrace on explain
select x, y, sum(z) from t group by x, y
/
pause

clear screen
create index t_idx on t(y,x,z);
select x, y, sum(z) from t group by x, y
/
pause
set autotrace off
clear screen

create or replace view v
as
select x, y, sum(z) "SUM(Z)" 
  from t 
 group by x, y 
 order by x, y;
pause

clear scr
begin
	sys.dbms_advanced_rewrite.declare_rewrite_equivalence
	( name             => 'DEMO_TIME',
	  source_stmt      => 'select x, y, sum(z) from t group by x, y',
	  destination_stmt => 'select * from v',
	  validate         => FALSE,
	  rewrite_mode     => 'TEXT_MATCH' );
end;
/
pause

clear screen
set autotrace on explain
select x, y, sum(z) from t group by x, y
/
pause
clear scr
select x, y, sum(z) from t FOR_REAL group by x, y
/
set autotrace off
pause
clear screen
exec sys.dbms_advanced_rewrite.drop_rewrite_equivalence( 'DEMO_TIME' );
