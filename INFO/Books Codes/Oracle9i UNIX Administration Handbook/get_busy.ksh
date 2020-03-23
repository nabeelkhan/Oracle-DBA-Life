#!/bin/ksh

# First, we must set the environment . . . .
ORACLE_SID=PROD
export ORACLE_SID
ORACLE_HOME=`cat /etc/oratab|grep \^$ORACLE_SID:|cut -f2 -d':'`
export ORACLE_HOME
PATH=$ORACLE_HOME/bin:$PATH
export PATH
MON=`echo ~oracle/mon`
export MON
ORA_ENVFILE=${ORACLE_HOME}/${ORACLE_SID}.env
. $ORA_ENVFILE

SERVER_NAME=`uname -a|awk '{print $2}'`
typeset -u SERVER_NAME
export SERVER_NAME

# sample every 10 seconds
SAMPLE_TIME=10

while true
do

   #*************************************************************
   # Test to see if Oracle is accepting connections
   #*************************************************************
   $ORACLE_HOME/bin/sqlplus -s /<<! > /tmp/check_$ORACLE_SID.ora
   select * from v\$database;
   exit
!

   #*************************************************************
   # If not, exit . . .
   #*************************************************************
   check_stat=`cat /tmp/check_$ORACLE_SID.ora|grep -i error|wc -l`;
   oracle_num=`expr $check_stat`
   if [ $oracle_num -eq 0 ]
      then



      rm -f /home/oracle/statspack/busy.lst
   
      $ORACLE_HOME/bin/sqlplus -s / <<!>/home/oracle/statspack/busy.lst

      set feedback off;
      select
         to_char(sysdate,'yyy-mm-dd HH24:mi:ss'), 
         event,
         substr(tablespace_name,1,14),
         p2
      from 
         v\$session_wait a, 
         dba_data_files  b
      where
         a.p1 = b.file_id
      and
         event in
         (
           'buffer busy waits',
           'enqueue'
         )
      ;

!

      var=`cat /home/oracle/statspack/busy.lst|wc -l`

      if [[ $var -gt 1 ]];
       then
          echo "***************************************************************"
          echo "There are waits"
          cat /home/oracle/statspack/busy.lst|\
              mailx -s "Monona block wait found"\
          dburleson@mwconline.com  
#         dhurley@mwconline.com \
          echo "***************************************************************"
       exit
      fi

      sleep $SAMPLE_TIME
   fi
done
