set echo on
@connect /
drop table t;
purge recyclebin;
clear screen

create table T as select * from dual;
pause
clear screen
drop table T;
pause
clear screen
exec print_table( q'|select * from user_recyclebin where original_name = 'T'|' )
pause
clear screen
select * from T;
flashback table T to before drop;
select * from T;
