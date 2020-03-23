#!/bin/ksh


if [ -z "$1" ]
then
   echo "Usage: statspack_alert.ksh <ORACLE_SID>"
   exit 99
fi

check=`cat /var/opt/oracle/oratab|grep -i $1|wc -l`
tmp=`expr $check`      # Convert string to number
if [ $tmp -lt 1 ]
then
   echo
   echo "Not a valid ORACLE_SID.  Retry."
   echo
   exit 99
fi

rm -f /tmp/statspack_alert.lst

ORACLE_SID=$1
export ORACLE_SID

ORACLE_HOME=`cat /var/opt/oracle/oratab|grep ^$ORACLE_SID:|cut -f2 -d':'`
export ORACLE_HOME

$ORACLE_HOME/bin/sqlplus /<<!
@/export/home/oracle/statspack/statspack_alert 9
exit
!

var=`cat /tmp/statspack_alert.lst|wc -l`

echo $var
if [[ $var -gt 1 ]];
 then
 echo "**********************************************************************"
 echo "There are alerts"
 cat /tmp/statspack_alert.lst|mailx -s "Statspack Alert" don@remote-dba.net terry.oakes@worldnet.att.net
 echo "**********************************************************************"
 exit
fi
