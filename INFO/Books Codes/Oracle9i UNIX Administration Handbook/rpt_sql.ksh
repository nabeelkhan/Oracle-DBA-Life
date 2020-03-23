#!/bin/ksh
 
# First, we must set the environment . . . .
ORACLE_SID=readtest
export ORACLE_SID
ORACLE_HOME=`cat /var/opt/oracle/oratab|grep ^$ORACLE_SID:|cut -f2 -d':'`
export ORACLE_HOME
PATH=$ORACLE_HOME/bin:$PATH
export PATH

echo "How many days back to search?"
read days_back

echo executions
echo loads
echo parse_calls
echo disk_reads
echo buffer_gets
echo rows_processed
echo sorts
echo 
echo "Enter sort key:"
read sortkey
 
$ORACLE_HOME/bin/sqlplus perfstat/perfstat<<! 

 
set array 1;
set lines 80;
set wrap on;
set pages 999;
set echo off;
set feedback off;

column mydate      format a8
column exec        format 9,999,999
column loads       format 999,999
column parse       format 999,999
column reads       format 9,999,999
column gets        format 9,999,999
column rows_proc   format 9,999,999
column inval       format 9,999
column sorts       format 999,999

drop table temp1;
create table temp1 as
   select min(snap_id) min_snap 
   from stats\$snapshot where snap_time > sysdate-$days_back;

drop table temp2;

create table temp2 as
select
   to_char(snap_time,'dd Mon HH24:mi:ss') mydate,
   executions                             exec,
   loads                                  loads,
   parse_calls                            parse,
   disk_reads                             reads,
   buffer_gets                            gets,
   rows_processed                         rows_proc,
   sorts                                  sorts,
   sql_text
from
   perfstat.stats\$sql_summary sql,
   perfstat.stats\$snapshot     sn
where
   sql.snap_id > 
   (select min_snap from temp1)
and
   sql.snap_id = sn.snap_id
order by $sortkey desc
;
spool off;

select * from temp2 where rownum < 11;

exit
!

