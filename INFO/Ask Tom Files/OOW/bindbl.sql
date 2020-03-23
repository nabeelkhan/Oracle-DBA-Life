set echo on
drop table t;
clear screen
create table t 
as
select owner, 
       object_id id1, cast( object_id as binary_double ) id2
  from all_objects
/
pause
clear screen
select owner, (sum(ln(id1))) - (sum(ln(id2)))  delta
  from t 
 group by owner
having (sum(ln(id1))) <> (sum(ln(id2))) 
/
pause
clear screen
alter session set sql_trace=true;
set autotrace traceonly statistics
select (sum(ln(id1))) from t group by owner;
pause
clear screen
select (sum(ln(id2))) from t group by owner;
set autotrace off
pause
clear screen
@connect /
host tkprof `ls -t $ORACLE_HOME/admin/$ORACLE_SID/udump/*ora_*.trc | head -1` ./tk.prf   sys=no 
edit tk.prf
