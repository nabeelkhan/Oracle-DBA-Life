set echo on
set linesize 121

clear screen
set autotrace on statistics
set pause on
select a.username, count(b.owner)
  from all_users a left join all_objects b
    on (a.username = b.owner)
 where a.username in ( user, 'SYSTEM' )
 group by a.username;
pause


clear screen
select a.username, (select count(*)
                      from all_objects b
                     where b.owner = a.username ) cnt
  from all_users a
 where a.username in ( user, 'SYSTEM' );
pause


clear screen
select a.username, 
(select count(*) from all_objects b where b.owner = a.username ) cnt,
(select min(created) from all_objects b where b.owner = a.username ) min_created,
(select max(created) from all_objects b where b.owner = a.username ) max_created
  from all_users a
 where a.username in ( user, 'SYSTEM' );
pause



clear screen
select username,
       to_number(substr(data,1,10)) cnt,
       to_date(substr(data,11,14),'yyyymmddhh24miss') min_created,
       to_date(substr(data,25),'yyyymmddhh24miss') max_created
  from (
select a.username, (select to_char( count(*), 'fm0000000000') ||
                           to_char( min(created),'yyyymmddhh24miss') || 
                           to_char( max(created),'yyyymmddhh24miss') 
                      from all_objects b where b.owner = a.username ) data
  from all_users a
 where a.username in ( user, 'SYSTEM' )
       );
pause


clear screen
create or replace type myType as object 
( cnt number, min_created date, max_created date )
/
select username, a.data.cnt, a.data.min_created, a.data.max_created
  from (
select a.username, (select myType( count(*), min(created), max(created) )
                      from all_objects b where b.owner = a.username ) data
  from all_users a
 where a.username in ( user, 'SYSTEM' )
       ) a;
pause

set autotrace off
set pause off
