#!/bin/ksh

#*****************************************************************
#
# Copyright (c) 2002 by Donald K. Burleson
#
# Licensing information may be found at www.dba-oracle.com
#
#*****************************************************************

# Exit if no first parameter $1
if [ -z "$1" ]
then
   echo "ERROR: Please pass a valid ORACLE_SID to this script"
   exit 99
fi

# Validate Oracle

TEMP=`cat /etc/oratab|grep \^$1:|cut -f1 -d':'|wc -l`
tmp=`expr TEMP`            # Convert string to number
if [ $tmp -ne 1 ]
then
   echo
   echo "ERROR: Your input parameter $1 is invalid.  Please Retry"
   echo
   exit 99
fi

if [ `whoami` != 'root' ]
then
   echo "Error: You must be root to execute the script.  Exiting."
   exit
fi

# First, we must set the environment . . . .
ORACLE_SID=$1
export ORACLE_SID

ORACLE_HOME=`cat /etc/oratab|grep ^$ORACLE_SID:|cut -f2 -d':'`
export ORACLE_HOME
PATH=$ORACLE_HOME/bin:$PATH:$ORACLE_HOME/lib
export PATH

APPL_TOP=`cat /etc/oratab|grep ^$ORACLE_SID|cut -d":" -f5`;
export APPL_TOP

. $ORACLE_HOME/$ORACLE_SID.env
. $APPL_TOP/APPL$ORACLE_SID.env

DB_NAME=$ORACLE_SID
export DB_NAME
 

#*******************************************************
# Stop the Forms Server
#*******************************************************
su - applmgr -c "/usr/local/bin/scripts/forms_server_stop.ksh $1" > /usr/local/bin/scripts/logs/forms_server_stop_$1

#Check for errors
test=`grep -i error /usr/local/bin/scripts/logs/forms_server_stop_$1|wc -l`
val=`expr $test`

if [ $val -gt 0 ]
then
   echo
   echo "ERROR: Errors found in /usr/local/bin/scripts/logs/forms_server_stop_$1." 
   grep -i error /usr/local/bin/scripts/logs/forms_server_stop_$1|mailx -s "$1 form shutdown error detected" dhurley@custom.com dburleson@custom.com
fi

#*******************************************************
# Stop the Concurrent manager
#*******************************************************
su - applmgr -c "/usr/local/bin/scripts/conc_mgr_stop.ksh $1" > /usr/local/bin/scripts/logs/conc_mgr_stop_$1

#Chek for errors
test=`grep -i error /usr/local/bin/scripts/logs/conc_mgr_stop_$1|wc -l`
val=`expr $test`

if [ $val -gt 0 ]
then
   eho
   eho "ERROR: Errors found in /usr/local/bin/scripts/logs/conc_mgr_stop_$1." 
   grep -i error /usr/local/bin/scripts/logs/conc_mgr_stop_$1|mailx -s "$1 concurrent manager shutdown error detected" dhurley@custom.com dburleson@custom.com
fi

#*******************************************************
# Stop the Webserver
#*******************************************************
su - oracle -c "/usr/local/bin/scripts/webserver_stop.ksh $1" > /usr/local/bin/scripts/logs/webserver_stop_$1

#Chek for errors
test=`grep -i error /usr/local/bin/scripts/logs/webserver_stop_$1|wc -l`
val=`expr $test`

if [ $val -gt 0 ]
then
   eho
   eho "ERROR: Errors found in /usr/local/bin/scripts/logs/webserver_stop_$1." 
   grep -i error /usr/local/bin/scripts/logs/webserver_stop_$1|mailx -s "$1 Webserver shutdown error detected" dhurley@custom.com dburleson@custom.com
fi

#*******************************************************
# Stop the listeners
#*******************************************************
su - oracle -c "/usr/local/bin/scripts/listener_stop.ksh $1" > /usr/local/bin/scripts/logs/listener_stop_$1

#Chek for errors
test=`grep -i error /usr/local/bin/scripts/logs/listener_stop_$1|wc -l`
val=`expr $test`

if [ $val -gt 0 ]
then
   eho
   eho "ERROR: Errors found in /usr/local/bin/scripts/logs/listener_stop_$1." 
   grep -i error /usr/local/bin/scripts/logs/listener_stop_$1|mailx -s "$1 Webserver shutdown error detected" dhurley@custom.com dburleson@custom.com
fi


