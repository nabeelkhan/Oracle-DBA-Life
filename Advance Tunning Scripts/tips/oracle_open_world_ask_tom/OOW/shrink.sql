@connect /
drop table t;

set echo on
clear screen
create table t 
ENABLE ROW MOVEMENT
as
select * 
  from all_objects;
pause


set termout off
select count(*) from t;
set termout on
clear screen
set autotrace on statistics
select count(*) from t;
set autotrace off
pause

clear screen
select blocks, cnt, tot_blocks, 
       sum(tot_blocks) over (order by blocks) running_total 
  from (
select blocks, count(*) cnt, blocks*count(*) tot_blocks
  from user_extents 
 where segment_name = 'T'
 group by blocks
       )
 order by blocks;
pause

clear screen
delete from t where mod(object_id,2) = 0;
commit;
pause

clear scr
alter table t shrink space compact;
alter table t shrink space;
pause

clear screen
select blocks, cnt, tot_blocks, 
       sum(tot_blocks) over (order by blocks) running_total 
  from (
select blocks, count(*) cnt, blocks*count(*) tot_blocks
  from user_extents 
 where segment_name = 'T'
 group by blocks
       )
 order by blocks;
pause

set termout off
select count(*) from t;
set termout on
clear scr
set autotrace on statistics
select count(*) from t;
set autotrace off
