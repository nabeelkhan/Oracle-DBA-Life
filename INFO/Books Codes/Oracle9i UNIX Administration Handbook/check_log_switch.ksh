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
     rsh $host "
     ORACLE_SID=${db}; export ORACLE_SID; 
     ORACLE_HOME=${home}; export ORACLE_HOME;
     ${home}/bin/sqlplus -s /<<!
     set pages 9999;
     select * from v"\\""$"database;
break on DB_NAME skip 2;

select  name DB_NAME,
        count(distinct tablespace_name) NUM_TS,
        count(distinct file_id) NUM_FILES,
        round(avg(switches)) AVG_LOGS 
from    v"\""$"database,
        dba_data_files,
        (select substr(first_time,1,8) day,
             count(*) switches
        from v"\""$"loghist
        group by substr(first_time,1,8))
group by name;
     exit
     !"
  done
done
