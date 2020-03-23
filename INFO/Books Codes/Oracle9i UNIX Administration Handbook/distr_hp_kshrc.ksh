#!/bin/ksh

#*****************************************************************
#
# Copyright (c) 2002 by Donald K. Burleson
#
# Licensing information may be found at www.dba-oracle.com
#
#*****************************************************************

# Loop through each host name . . . 
for host in `echo spp01 spp02 spp03 dtsgdev`
do
  echo " "
  echo "************************"
  echo "$host"
  echo "************************"
  #
  #************************************************
  #  Add your rcp command below . . . 
  #************************************************
  rsh $host "ls -al .k*"
  rsh $host "chmod 700 .kshrc"
  rcp -p /u/oracle/all/.kshrc_hp ${host}:~oracle/.kshrc
  echo " "
  rsh $host "chmod 500 .kshrc"
  rsh $host "ls -al .k*"
done
