# Capture IDLM statistics - (c) 1998 by Donald Keith Burleson
DAY_OF_WEEK=`date +"%A"`
MACHINE_NAME=`hostname`
REPORT_FILE=/oracle/HOME/dba_reports/dlm_monitor.${MACHINE_NAME}.${DAY_OF_WEEK}.l
og
#
# Set up the file to log the lock to:
#
TIMESTAMP=`date +"%C%y.%m.%d-%H:%M:%S"`
DLM_RESOURCES=`/oracle/HOME/bin/lkdump -a res | head -2 | awk 'getline'`
DLM_LOCKS=`/oracle/HOME/bin/lkdump -a lock | head -2 | awk 'getline' `
DLM_PROCESS=`/oracle/HOME/bin/lkdump -a proc | head -2 | awk 'getline'`
printf "$TIMESTAMP  $DLM_RESOURCES  $DLM_LOCKS  $DLM_PROCESS \n" >> $REPORT_FILE

RES=`echo $DLM_RESOURCES|cut -f2 -d '='`
LOC=`echo $DLM_LOCKS|cut -f2 -d '='`
PRO=`echo $DLM_PROCESS|cut -f2 -d '='`

ORACLE_SID=HOME; export ORACLE_SID;
PATH=$PATH:/oracle/HOME/bin; export PATH;
ORACLE_HOME=/oracle/HOME; export ORACLE_HOME;

/oracle/HOME/bin/sqlplus <<! >> /dev/null

connect perfstat/perfstat;

insert into perfstat.stats$idlm_stats 
 values (
   SYSDATE,
   $PRO,
   $RES,
   $LOC );

exit;
!

