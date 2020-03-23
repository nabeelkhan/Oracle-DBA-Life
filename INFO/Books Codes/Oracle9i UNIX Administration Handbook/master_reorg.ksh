#!/bin/ksh
# Written by Donald Keith Burleson
# usage: nohup don_reorg.ksh > don_reorg.lst 2>&1 &


# Ensure that running user is oracle . . . . .
oracle_user=`whoami|grep oracle|grep -v grep|wc -l`;
oracle_num=`expr $oracle_user`
if [ $oracle_num -lt 1 ]
 then echo "Current user is not oracle. Please su to oracle and retry."
 exit
fi

# Ensure that Oracle is running . . . . .
oracle_up=`ps -ef|grep pmon|grep -v grep|wc -l`;
oracle_num=`expr $oracle_up`
if [ $oracle_num -lt 1 ]
 then echo "ORACLE instance is NOT up. Please start Oracle and retry."
 exit
fi

#************************************************************
# Submit parallel CTAS reorganizations of important tables
#************************************************************
nohup reorg.ksh CUSTOMER  >customer.lst  2>&1 &
nohup reorg.ksh ORDER     >order.lst     2>&1 &
nohup reorg.ksh ITEM      >item.lst      2>&1 &
nohup reorg.ksh LINE_ITEM >line_item.lst 2>&1 &
nohup reorg.ksh PRODUCT   >product.lst   2>&1 &

