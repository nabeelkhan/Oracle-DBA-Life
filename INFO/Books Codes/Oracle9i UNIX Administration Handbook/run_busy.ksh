#!/bin/ksh

# First, we must set the environment . . .
statspack=`echo ~oracle/statspack`
export statspack
ORACLE_SID=PROD
export ORACLE_SID
ORACLE_HOME=`cat /etc/oratab|grep $ORACLE_SID:|cut -f2 -d':'`
export ORACLE_HOME
PATH=$ORACLE_HOME/bin:$PATH
export PATH

#----------------------------------------
# If it is not running, then start it . . .
#----------------------------------------
check_stat=`ps -ef|grep get_busy|grep -v grep|wc -l`;
oracle_num=`expr $check_stat`
if [ $oracle_num -le 0 ]
 then nohup $statspack/get_busy.ksh > /dev/null 2>&1 &
fi
