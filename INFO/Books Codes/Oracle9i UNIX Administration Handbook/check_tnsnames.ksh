#!/bin/ksh
#*****************************************************************
#
# Copyright (c) 2002 by Donald K. Burleson
#
# Licensing information may be found at www.dba-oracle.com
#
#*****************************************************************

# Loop through each host name . . . 
for host in `cat ~oracle/.rhosts|cut -d"." -f1|awk '{print $1}'|sort -u`
do
  echo " "
  echo "************************"
  echo "$host"
  echo "************************"
  # Loop through each database name on the host. . . 
  for db in `rsh $host "cat /etc/oratab|egrep ':N|:Y'|grep -v \*|cut -f1 -d':'"`
  do
     # Get the ORACLE_HOME for each database
     home=`rsh $host "cat /etc/oratab|egrep ':N|:Y'|grep -v \*|grep ${db}|cut -f2 -d':'"`
     echo " "
     echo "database is $db"
     #echo "home is is $home"
     # check the size of the tnsnames.ora file
     rsh $host "ls -al ${home}/network/admin/tnsnames.ora"
#     sqlplus -s /<<!
#     set pages 9999;
#
#from v\$parameter@$db
#where name  in ('nls_date_format','nls_language');
#     exit
#!
  done
done
