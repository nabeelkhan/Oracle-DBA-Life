#!/bin/ksh

#*****************************************************************
#
# Copyright (c) 2002 by Donald K. Burleson
#
# Licensing information may be found at www.dba-oracle.com
#
#*****************************************************************

if [ `whoami` != 'oracle' ]
then
   echo "Error: You must be oracle to execute the script.  Exiting."
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

. $ORACLE_HOME/$ORACLE_SID.env;
. $APPL_TOP/APPL$ORACLE_SID.env
 

FORMS_PORT=`cat /etc/oratab|grep ^$ORACLE_SID | awk -F: '{print $6}' -`
TCF_PORT=`cat /etc/oratab|grep ^$ORACLE_SID | awk -F: '{print $7}' -`
NLS_FORMS_PORT=`cat /etc/oratab|grep ^$ORACLE_SID | awk -F: '{print $8}' -`

DB_NAME=$ORACLE_SID
export DB_NAME


owsctl stop lprd
owsctl stop admin
owsctl stop wrb
