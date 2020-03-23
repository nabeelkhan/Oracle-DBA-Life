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
#for host in `echo sp2mr1 sp2mr2 sp2pr2`
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
     echo "    ------------------------"
     echo "    Database is $db"
     echo "    ------------------------"
     #echo "home is is $home"
     rsh $host "
     ORACLE_SID=${db}; export ORACLE_SID; 
     ORACLE_HOME=${home}; export ORACLE_HOME;
     ${home}/bin/sqlplus -s /<<!
     set pages 9999;
     set heading off;
     set echo off;
     set feedback off;
     column c1 format a30;
     column c2 format a40;
     select name c1, value c2 from v"\\""$"parameter where 
     name in (
       'hash_joined_enabled ',
       'hash_area_size',
       'hash_multiblock_io_count',
       'v733_plans_enabled',
       'create_bitmap_area_size',
       'b_tree_bitmap_plans',
       'partition_view_enabled',
       'optimizer_percent_parallel',
       'fast_full_scan_enabled',
       'always_anti_join'
     );
     exit
     !"
  done
done
