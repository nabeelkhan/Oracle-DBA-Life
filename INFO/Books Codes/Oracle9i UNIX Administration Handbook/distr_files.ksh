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
  #
  #************************************************
  #  Add your rcp command below . . . 
  #************************************************
  rcp -p /etc/xxxx ${host}:/etc/xxxx
done
