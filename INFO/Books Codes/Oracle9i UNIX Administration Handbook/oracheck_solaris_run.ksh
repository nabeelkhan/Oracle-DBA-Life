#!/bin/ksh

#*****************************************************************
#
# Copyright (c) 1999 by Donald K. Burleson
#
# This program is NOT freeware or shareware
# and remains the exclusive property of Donald K. Burleson
# and Burleson Enterprises Inc.
#
# Licensing information may be found at www.dba-oracle.com
#
#*****************************************************************

# Ensure that the parms have been passed to the script
if [ -z "$1" ]
then
   echo "Usage: oracheck.run <ORACLE_SID>"
   exit 99
fi

var=`cat /var/opt/oracle/oratab|grep -v "#"|cut -d: -f1|grep ${1}|wc -l`

oracle_num=`expr $var`
if [ $oracle_num -ne 1 ]
 then
 echo "The variable ${1} is not a valid ORACLE_SID.  Please retry."
 exit 0
fi

ORACLE_SID=${1}
export ORACLE_SID

ORACLE_HOME=`cat /var/opt/oracle/oratab|grep ^$ORACLE_SID:|cut -f2 -d':'`
export ORACLE_HOME

#*************************************************************
# Get the Oracle users home directory from /etc/passwd
#*************************************************************
ora_unix_home_dir=`cat /etc/passwd|grep ^oracle|cut -f6 -d':'`
#echo home dir = $ora_unix_home_dir

#*************************************************************
# Here we gather the values from the parm files . . . 
#*************************************************************
if [ -f ${ora_unix_home_dir}/mon/parm_ts_free_$ORACLE_SID.ora ]
then
   TS_FREE=`cat ${ora_unix_home_dir}/mon/parm_ts_free_$ORACLE_SID.ora`
else
   TS_FREE=`cat ${ora_unix_home_dir}/mon/parm_ts_free.ora`
fi
 
if [ -f ${ora_unix_home_dir}/mon/parm_num_extents_$ORACLE_SID.ora ]
then
   NUM_EXTENTS=`cat ${ora_unix_home_dir}/mon/parm_num_extents_$ORACLE_SID.ora`
else
   NUM_EXTENTS=`cat ${ora_unix_home_dir}/mon/parm_num_extents.ora`
fi


if [ -f ${ora_unix_home_dir}/mon/parm_mount_point_kb_free_$ORACLE_SID.ora ]
then
   KB_FREE=`cat ${ora_unix_home_dir}/mon/parm_mount_point_kb_free_$ORACLE_SID.ora`
else
   KB_FREE=`cat ${ora_unix_home_dir}/mon/parm_mount_point_kb_free.ora`
fi

#*************************************************************
# E-mailx setup
# Here we setup the $dbalist variable to send messages to the right DBA's
#*************************************************************

case $ORACLE_SID in
     "readprod" ) 
        dbalist='don@remote-dba.net, terry.oakes@worldnet.att.net' ;;
esac

#*************************************************************
# Let's exit immediately if the database is not running . . .  
#*************************************************************
check_stat=`ps -ef|grep ${ORACLE_SID}|grep pmon|wc -l`;
oracle_num=`expr $check_stat`
if [ $oracle_num -lt 1 ]
 then
 exit 0
fi

#*************************************************************
# Test to see if Oracle is accepting connections
#*************************************************************
$ORACLE_HOME/bin/sqlplus -s /<<! > /tmp/check_$ORACLE_SID.ora
select * from v\$database;
exit
!

#*************************************************************
# If not, exit immediately . . .  
#*************************************************************
check_stat=`cat /tmp/check_$ORACLE_SID.ora|grep -i error|wc -l`;
oracle_num=`expr $check_stat`
if [ $oracle_num -gt 0 ]
 then
 exit 0
fi

#echo db is up


rm -f /tmp/alert_log_dir_${ORACLE_SID}.ora
rm -f /tmp/log_archive_start_${ORACLE_SID}.ora
rm -f /tmp/log_archive_dest_${ORACLE_SID}.ora
rm -f /tmp/dump*${ORACLE_SID}.ora
rm -f /tmp/ora600_${ORACLE_SID}.ora
rm -f /tmp/arch_${ORACLE_SID}.ora
 
#*************************************************************
# Get details from Oracle dictionary
#*************************************************************
$ORACLE_HOME/bin/sqlplus -s /<<!

@${ora_unix_home_dir}/mon/get_dict_parm $ORACLE_HOME $ORACLE_SID

exit
!

#cat /tmp/dump*

#*************************************************************
# If the first character of the dump directory is a question-mark (?)
# then replace it with $ORACLE_HOME
#*************************************************************
sed 's/?/$ORACLE_HOME/g' /tmp/dump_$ORACLE_SID.ora > /tmp/dump1_$ORACLE_SID.ora

ALERT_DIR=`cat /tmp/alert_log_dir_${ORACLE_SID}.ora|awk '{print $1}'`
export ALERT_DIR

#*************************************************************
# If the first character of the alert ora directory is a question-mark (?)
# then prefix with $ORACLE_HOME
#*************************************************************

first_char=`echo $ALERT_DIR|grep ^?|wc -l`
first_num=`expr $first_char`
#echo $first_char
if [ $first_num -eq 1 ]
then 
  new=`echo $ALERT_DIR|cut -d? -f2`
  ALERT_DIR=${ORACLE_HOME}$new
fi



#***********************************************************
# Check alert ora for ORA-600 and other ORA errors
# The list of ORA messages is in the file called parm_alert_log.ora
#***********************************************************

for MSG in `cat ${ora_unix_home_dir}/mon/parm_alert_log.ora`
do
  tail -400 $ALERT_DIR/alert_$ORACLE_SID.log|grep $MSG >> /tmp/ora600_${ORACLE_SID}.ora
done

#*************************************************************
# Only send the alert if there is an error in the output . . . . 
#*************************************************************
check_stat=`cat /tmp/ora600_${ORACLE_SID}.ora|wc -l`;
oracle_num=`expr $check_stat`
if [ $oracle_num -ne 0 ]
then
   #*************************************************************
   # Only send the alert if there is a change to the output . . . . 
   #*************************************************************
   newm=`diff /tmp/ora600_${ORACLE_SID}.ora /tmp/ora600_${ORACLE_SID}.old|wc -l`
   chgflg=`expr $newm`
   if [ $chgflg -ne 0 ]
   then
      #*************************************************************
      # Mail the message to the DBA's in $dbalist
      #*************************************************************
      cat /tmp/ora600_${ORACLE_SID}.ora|mailx -s "$ORACLE_SID alert log message detected" $dbalist 
   fi
fi

cp /tmp/ora600_${ORACLE_SID}.ora /tmp/ora600_${ORACLE_SID}.old
rm -f /tmp/oracheck_${ORACLE_SID}.ora

# Here we write a blank line to the ora file . . . 
echo `date` > /tmp/oracheck_${ORACLE_SID}.ora 

#*************************************************************
# Now we run the check, writing errors to the oracheck.ora file 
#*************************************************************
~oracle/mon/oracheck.ksh ${ORACLE_SID} ${TS_FREE} ${NUM_EXTENTS} >> /tmp/oracheck_${ORACLE_SID}.ora

#**************************************************************
# This section checks the Oracle mount points 
#**************************************************************

#*************************************************************
# Get the Oracle users home directory from /etc/passwd
#*************************************************************
ora_unix_home_dir=`cat /etc/passwd|grep ^oracle|cut -f6 -d':'`
#echo home dir = $ora_unix_home_dir


#*************************************************************
# Set-up the dialect changes for HP/UX and AIX (df -k) vs (bdf) 
#*************************************************************

dialect_df="df -k"

#*************************************************************
# Get the free space from the archived redo log directory 
#*************************************************************
LOG_ARCHIVE_START=`cat /tmp/log_archive_start_${ORACLE_SID}.ora|awk '{print $1}'`
export LOG_ARCHIVE_START

#echo $LOG_ARCHIVE_START
if [ $LOG_ARCHIVE_START = 'TRUE' ]
then 

   LOG_ARCHIVE_DEST=`cat /tmp/log_archive_dest_${ORACLE_SID}.ora|awk '{print $1}'`
   export LOG_ARCHIVE_DEST
   
   nohup ${dialect_df} $LOG_ARCHIVE_DEST > /tmp/arch_${ORACLE_SID}.ora 2>&1 &
   
   # The above could be not found . . .
   flag1=`cat /tmp/arch_${ORACLE_SID}.ora|grep find|wc -l`
   #*************************************************************
   # If the log archive dest is not found, truncate last entry
   #*************************************************************
   free_space_num=`expr ${flag1}`
   if [ $free_space_num -eq 1 ]
   then
     echo $LOG_ARCHIVE_DEST|sed 's/\/arch//g' > /tmp/arch1_$ORACLE_SID.ora
     LOG_ARCHIVE_DEST=`cat /tmp/arch1_$ORACLE_SID.ora`
   fi
   
   #  This ugly code is because bdf and df -k have free space in different columns
   if [ $os = "IRIX64" ]
   then
      arch_dir_mp=`${dialect_df} $LOG_ARCHIVE_DEST|grep -v kbytes|awk '{ print $7 }'`
      arch_free_space=`${dialect_df} ${arch_dir_mp}|grep -v kbytes|awk '{ print $3 }'`
   fi
   if [ $os = "AIX" ]
   then
      arch_dir_mp=`${dialect_df} $LOG_ARCHIVE_DEST|grep -v blocks|awk '{ print $7 }'`
      arch_free_space=`${dialect_df} ${arch_dir_mp}|grep -v blocks|awk '{ print $3 }'`
   fi
   if [ $os = "OSF1" ]
   then
      arch_dir_mp=`${dialect_df} $LOG_ARCHIVE_DEST|grep -v blocks|awk '{ print $7 }'`
      arch_free_space=`${dialect_df} ${arch_dir_mp}|grep -v blocks|awk '{ print $3 }'`
   fi
   if [ $os = "HP-UX" ]
   then
      arch_dir_mp=`${dialect_df} $LOG_ARCHIVE_DEST|grep -v kbytes|awk '{ print $6 }'`
      arch_free_space=`${dialect_df} ${arch_dir_mp}|grep -v kbytes|awk '{ print $4 }'`
   fi
   
   #echo $LOG_ARCHIVE_DEST
   #echo $arch_dir_mp
   #echo $arch_free_space
   
   #*************************************************************
   # Now, display if free space is < ${KB_FREE}
   #*************************************************************
   free_space_num=`expr ${arch_free_space}`
   kb_free_num=`expr ${KB_FREE}`
   #echo $free_space_num
   if [ $free_space_num -lt ${kb_free_num} ]
    then
      #*************************************************************
      # Display a message on the operations console
      #*************************************************************
         echo "NON-EMERGENCY ORACLE ALERT. Mount point ${ora_unix_home_mp1} has less than ${KB_FREE} K-Bytes free."|mailx -s "Rovia Alert Detected" $dbalist
      exit 67
   fi
fi   
#*************************************************************
# get the mount point associated with the home directory
#*************************************************************

#echo $ora_unix_home_dir
#df -k $ora_unix_home_dir

ora_unix_home_mp=`${dialect_df} ${ora_unix_home_dir}|sed 1,1d|awk '{ print $6}'`
#echo mp1 = $ora_unix_home_mp
ora_unix_home_mp1=`echo ${ora_unix_home_mp}|awk '{ print $2 }'`

#*************************************************************
# Get the free space for the mount point for UNIX home directory
#*************************************************************

ora_unix_home_fr1=`${dialect_df} ${ora_unix_home_mp}|sed 1,1d|awk '{ print $4}'`

#echo free = $ora_unix_home_fr1

#*************************************************************
# Now, display if free space is < ${KB_FREE}
#*************************************************************
free_space_num=`expr ${ora_unix_home_fr1}`
kb_free_num=`expr ${KB_FREE}`
#echo $free_space_num
if [ $free_space_num -lt ${kb_free_num} ]
 then 
   #*************************************************************
   # Display a message on the operations console
   #*************************************************************
   echo "NON-EMERGENCY ORACLE ALERT. Mount point ${ora_unix_home_mp1} has less than ${KB_FREE} K-Bytes free." |mailx -s "Rovia Alert Detected" $dbalist
   exit 67
fi

chmod +x /tmp/dump1_$ORACLE_SID.ora

#*************************************************************
# Now we execute this file to get the free space in the filesystem
#*************************************************************
/tmp/dump1_$ORACLE_SID.ora > /tmp/dump2_$ORACLE_SID.ora

loop=1
#*************************************************************
# Here we loop to get all free space numbers and check each
#*************************************************************
for free_num in `cat /tmp/dump2_$ORACLE_SID.ora`
do
    #echo loop = $loop
    mp=`cat /tmp/dump1_$ORACLE_SID.ora|awk '{print $2'}`
    mp1=`echo $mp|awk '{print$'$loop'}'`
    #echo point = $mp1
    free_space_num=`expr ${free_num}`
    #echo $free_space_num
    if [ $free_space_num -lt $kb_free_num ]
    then 
      #*************************************************************
      # Display a message on the operations console
      #*************************************************************
       echo "NON-EMERGENCY ORACLE ALERT. The mount point for $mp1 has less than ${KB_FREE} K-Bytes free."|mailx -s "Rovia Alert Detected" $dbalist
       loop="`expr $loop + 1`"
    fi
done


#*************************************************************
# If errors messages exist (2 or more lines), then go on . . . 
#*************************************************************
if [ `cat /tmp/oracheck_${ORACLE_SID}.ora|wc -l` -ge 2 ]
then
   #*************************************************************
   # Display a message on the operations console
   #*************************************************************
   echo "NON-EMERGENCY ORACLE ALERT. Contact the DBA and report this error ===>"` cat /tmp/oracheck_${ORACLE_SID}.ora`|mailx -s "Rovia Alert Detected" $dbalist
   exit 69
fi
