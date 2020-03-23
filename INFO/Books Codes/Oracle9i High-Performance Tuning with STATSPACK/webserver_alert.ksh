#!/bin/ksh

MYDATE=`date +"%Y%m%d"`

SERVER=`uname -a|awk '{print $2}'`

if [ -f /usr/src/asp/core ]
then

   # Move the file to a dated location . . .
   mv /usr/src/asp/core /tmp/core_$MYDATE

   # send an e-mail to the administrator
   head /tmp/core_$MYDATE|\
   mail -s "EMERGENCY - WebServer $SERVER abort in /tmp/core_$MYDATE"\
      don@remote-dba.net\
      omar@oracle.com\
      carlos@oracle.com

fi
