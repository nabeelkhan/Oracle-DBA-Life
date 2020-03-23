#!/bin/ksh

#*****************************************************************
#
# Copyright (c) 2002 by Donald K. Burleson
#
# Licensing information may be found at www.dba-oracle.com
#
#*****************************************************************


# Loop through each host name . . . 
for host in `echo dssseth sg40 ssev1 sss01 spdd02 sdds03` do
  echo " "
  echo "************************"
  echo "$host"
  echo "************************"
  #
  #************************************************
  #  Add your rcp command below . . . 
  #************************************************
  rsh $host "ls -al .p*"
  rsh $host "chmod 700 .profile"
  rcp -p /u/oracle/.profile ${host}:~oracle/.profile
  echo " "
  rsh $host "chmod 500 .profile"
  rsh $host "ls -al .p*"
done
