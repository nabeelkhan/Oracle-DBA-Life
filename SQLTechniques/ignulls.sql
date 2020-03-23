column val clear
set echo on
set linesize 121
drop table t;

clear screen
create table t ( dt date, val number );
insert into t 
select sysdate-100+rownum, decode(mod(rownum,4),1,user_id)
  from (select * from all_users order by user_id desc )
 where rownum <= 10;
pause


clear screen
select dt, val
  from t
 order by dt;
pause


clear screen
select dt, val,
       case when val is not null
	   then to_char(row_number() over (order by dt),'fm0000')||val
	   end max_val
  from t
 order by dt;
pause


clear screen
select dt, val, 
       to_number(substr(max(max_val) over (order by dt),5)) max_val
  from (
select dt, val,
       case when val is not null
	   then to_char(row_number() over (order by dt),'fm0000')||val
	   end max_val
  from t
       )
 order by dt
/
pause


clear screen
select dt, val,
       last_value(val ignore nulls) over (order by dt) val
  from t
 order by dt
/
pause
