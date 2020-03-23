set echo on
set linesize 121

clear screen
variable x varchar2(20)
variable n number
exec :x := '01-jan-2005'
exec :n := 5
set autotrace on
set pause on
select to_date(:x,'dd-mon-yyyy')+level-1
  from dual
connect by level <= :n
/
set autotrace off
set pause off
