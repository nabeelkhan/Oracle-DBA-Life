#!/bin/ksh

# First, we must set the environment . . . .
ORACLE_SID=$ORACLE_SID
export ORACLE_SID
ORACLE_HOME=`cat /etc/oratab|grep ^$ORACLE_SID:|cut -f2 -d':'`
#ORACLE_HOME=`cat /var/opt/oracle/oratab|grep ^$ORACLE_SID:|cut -f2 -d':'`
export ORACLE_HOME
PATH=$ORACLE_HOME/bin:$PATH
export PATH

echo "Please enter the number of seconds between snapshots."
read elapsed


$ORACLE_HOME/bin/sqlplus perfstat/perfstat<<!
execute statspack.snap;
exit
!

sleep $elapsed

$ORACLE_HOME/bin/sqlplus perfstat/perfstat<<!
execute statspack.snap;

select 
   name,
   snap_id,
   to_char(snap_time,' dd Mon YYYY HH24:mi:ss')  
from
   stats\$snapshot,
   v\$database
where 
   snap_id > (select max(snap_id)-2 from stats\$snapshot)
;

@rpt_last

