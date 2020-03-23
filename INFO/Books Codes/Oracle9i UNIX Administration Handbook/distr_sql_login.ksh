#!/bin/ksh

#*****************************************************************
#
# Copyright (c) 2002 by Donald K. Burleson
#
# Licensing information may be found at www.dba-oracle.com
#
#*****************************************************************


# Loop through each host name . . . 
for host in `cat .rhosts|cut -d"." -f1|awk '{print $1}'|sort -u`
do
  echo " "
  echo "************************"
  echo "$host"
  echo "************************"
  #
  #************************************************
  #  Add your rcp command below . . . 
  #************************************************
  rsh $host "ls -al /u01/app/oracle/admin/site/login.sql"
  rsh $host "chmod 700 /u01/app/oracle/admin/site/login.sql"
  rcp -p /u01/app/oracle/admin/site/login.sql ${host}:/u01/app/oracle/admin/site/login.sql
  echo " "
  rsh $host "chmod 500 /u01/app/oracle/admin/site/login.sql"
  rsh $host "ls -al /u01/app/oracle/admin/site/login.sql"
done
