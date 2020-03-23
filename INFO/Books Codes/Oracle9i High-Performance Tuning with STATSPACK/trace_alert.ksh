#!/bin/ksh

#******************************************************
# Exit if no first parameter $1 is passed to script
#******************************************************
if [ -z "$1" ]
then
   echo "Usage: trace_alert.ksh <ORACLE_SID>"
   exit 99
fi

#******************************************************
# First, we must set the environment . . . .
#******************************************************
ORACLE_SID=$1
export ORACLE_SID
ORACLE_HOME=`cat /var/opt/oracle/oratab|grep $ORACLE_SID:|cut -f2 -d':'`
export ORACLE_HOME
ORACLE_BASE=`echo $ORACLE_HOME | sed -e 's:/product/.*::g'`
export ORACLE_BASE
export DBA=$ORACLE_BASE/admin;
export DBA
PATH=$ORACLE_HOME/bin:$PATH
export PATH
MON=`echo ~oracle/mon`
export MON

#******************************************************
# Get the server name & date for the e-mail message
#******************************************************
SERVER=`uname -a|awk '{print $2}'`

MYDATE=`date +"%m/%d %H:%M"`


#******************************************************
# Remove the old file list
#******************************************************
rm -f /tmp/trace_list.lst
touch /tmp/trace_list.lst

#******************************************************
# list the full-names of all possible dump files . . . . 
#******************************************************
find $DBA/$ORACLE_SID/bdump/*.trc   -mtime -1 -print >>  /tmp/trace_list.lst
find $DBA/$ORACLE_SID/udump/*.trc   -mtime -1 -print >> /tmp/trace_list.lst
find $ORACLE_HOME/rdbms/log/*.trc   -mtime -1 -print >> /tmp/trace_list.lst

#******************************************************
# Exit if there are not any trace files found
#******************************************************
NUM_TRACE=`cat /tmp/trace_list.lst|wc -l`
oracle_num=`expr $NUM_TRACE`
if [ $oracle_num -lt 1 ]
 then
 exit 0
fi

#echo $NUM_TRACE files found
#cat /tmp/trace_list.lst


#******************************************************
# for each trace file found, send DBA an e-mail message
#  and move the trace file to the /tmp directory
#******************************************************
cat /tmp/trace_list.lst|while read TRACE_FILE
do

   #***************************************************
   #  This gets the short file name at the end of the full path
   #***************************************************
   SHORT_TRACE_FILE_NAME=`echo $TRACE_FILE|awk -F"/" '{ print $NF }'`
   #***************************************************
   #  This gets the file location (bdump, udump, log) 
   #***************************************************
   DUMP_LOC=`echo $TRACE_FILE|awk -F"/" '{ print $(NF-1) }'`

   #***************************************************
   # send an e-mail to the administrator
   #***************************************************

   head -100 $TRACE_FILE|\
   mailx -s "$ORACLE_SID Oracle trace file at $MYDATE."\
      don@remote-dba.net\
      terry@oracle.net\
      tzu@oracle.com
   #***************************************************
   # Move the trace file to the /tmp directory
   # This prevents multiple messages to the developers
   # and allows the script to run every minute
   #***************************************************

   cp $TRACE_FILE /tmp/${DUMP_LOC}_${SHORT_TRACE_FILE_NAME}
   rm -f $TRACE_FILED

done
