#!/bin/ksh
 
# First, we must set the environment . . . .
ORACLE_SID=PHNX
export ORACLE_SID
ORACLE_HOME=`cat /etc/oratab|grep ^$ORACLE_SID:|cut -f2 -d':'`
export ORACLE_HOME
PATH=$ORACLE_HOME/bin:$PATH
export PATH
 
$ORACLE_HOME/bin/sqlplus perfstat/perfstat<<! 

execute statspack.snap;

exit
!

