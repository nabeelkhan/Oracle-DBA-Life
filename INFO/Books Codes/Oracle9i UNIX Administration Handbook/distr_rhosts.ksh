#!/bin/ksh

#*****************************************************************
#
# Copyright (c) 2002 by Donald K. Burleson
#
# Licensing information may be found at www.dba-oracle.com
#
#*****************************************************************


filetag=`date +"%y%m%d"`

# Loop through each host name . . . 
for host in `cat ~oracle/.rhosts|cut -d"." -f1|awk '{print $1}'|sort -u`
do
  echo " "
  echo "************************"
  echo "$host"
  echo "************************"
  #
  #
  rsh $host "ls -al .r*"
  rsh $host "cp .rhosts .rhosts_${filetag}"
  echo "************************"
  rsh $host "ls -al .r*"
  echo "************************"
  rcp -p ~oracle/.rhosts $host:
  rsh $host "ls -al .r*"
done
