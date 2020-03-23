#!/bin/ksh
 
# First, we must set the environment . . . .
ORACLE_SID=readprod
export ORACLE_SID
ORACLE_HOME=`cat /var/opt/oracle/oratab|grep ^$ORACLE_SID:|cut -f2 -d':'`
export ORACLE_HOME
PATH=$ORACLE_HOME/bin:$PATH
export PATH
 
$ORACLE_HOME/bin/sqlplus reader/reader<<! 

select * from v\$database;
set heading off;
set lines 999;
 
select count(*) from perfstat.stats\$snapshot where snap_time < sysdate - 30;
select count(*) from perfstat.stats\$snapshot where snap_time > sysdate - 30;
delete from perfstat.stats\$snapshot where snap_time < sysdate - 30;
exit
!
