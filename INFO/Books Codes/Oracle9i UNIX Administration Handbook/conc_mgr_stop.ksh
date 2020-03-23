#!/bin/ksh

#*****************************************************************
#
# Copyright (c) 2002 by Donald K. Burleson
#
# Licensing information may be found at www.dba-oracle.com
#
#*****************************************************************

if [ `whoami` != 'applmgr' ]
then
   echo "Error: You must be applmgr to execute the script.  Exiting."
   exit
fi

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
   echo "Your input parameter $1 is invalid.  ERROR: Please Retry"
   echo
   exit 99
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


echo "Shutting down concurrent managers for $DB_NAME ..."

echo $FND_TOP


if [ $DB_NAME = "PROD" ]; then
     $FND_TOP/bin/CONCSUB apps/appsmwc SYSADMIN 'System Administrator' SYSADMIN CONCURRENT FND SHUTDOWN
else
     $FND_TOP/bin/CONCSUB apps/apps SYSADMIN 'System Administrator' SYSADMIN CONCURRENT FND SHUTDOWN 
fi
