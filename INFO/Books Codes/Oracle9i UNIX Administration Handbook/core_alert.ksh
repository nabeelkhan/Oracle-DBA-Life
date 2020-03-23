#!/bin/ksh

MYDATE=`date +"%Y%m%d"`

SERVER=`uname -a|awk '{print $2}'`

if [ -f /usr/local/src/rsp_server-0.01/inetd_copy/core ]
then

   # Move the file to a dated location . . .
   mv /usr/local/src/rsp_server-0.01/inetd_copy/core /tmp/core_$MYDATE

   # send an e-mail to the administrator
   head /tmp/core_$MYDATE|\
   mail -s "EMERGENCY - WebServer $SERVER abort in /tmp/core_$MYDATE"\
      don@remote-dba.net\
      omar@rovia.com\
      carlos@rovia.com

   # Remove all connections for this WebServer from the testb1 database
   su - oracle -c "/usr/app/oracle/admin/product/8/1/6/bin/sqlplus reader/reader@testb1<<!
   select count(*) from current_logons;
   delete from current_logons where webserver_name = '$SERVER';
   select count(*) from current_logons;
   exit
!"

   # Remove all connections for this WebServer from the testb2 database
   su - oracle -c "/usr/app/oracle/admin/product/8/1/6/bin/sqlplus reader/reader@testb2<<!
   select count(*) from current_logons;
   delete from current_logons where webserver_name = '$SERVER';
   select count(*) from current_logons;
   exit
!"

fi
