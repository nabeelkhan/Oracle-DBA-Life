#!/bin/ksh
#------------------------------------------------------------------------------------------
#
# StatspackCleanup.ksh
#
#   This script is used to cleanup old STATSPACK statistics.  It accepts a start and 
# end date range.  If the beginning date is not supplied then 01-JAN-1900 is assumed.  If
# an end date range (most recent date) is not given, then $SAVE_DAYS number of days ago is 
# assumed, which is a program env. variable.
#
#   For the call of $ORACLE_HOME/rdbms/admin/sppurge.sql to work properly in batch, the
# "undefine" of variables losnapid and hisnapid must be removed from the .sql script.
#
# Arguments:
#	-b <date>	Begin date, in 'DD-MON-YYYY HH24:MI:SS' format.
#	-e <date>	End date, in 'DD-MON-YYYY HH24:MI:SS' format.
#
#------------------------------------------------------------------------------------------

integer COUNTER=1
integer SAVE_DAYS=14
SP_NEXT_DATE=
SP_INSTANCE=
SP_INTERVAL=
SQLPLUS_SETTINGS="set echo off feedback off heading off linesize 32767 pagesize 0 tab off termout off"
STATSPACK_USER="perfstat"
STOP_JOBID=
THISFILE=$(basename $0)

#------------------------------------------------------------------------
function USAGE
{
	echo "$THISFILE -b <Begin datetime> -e <End datetime>"
	exit -1
}

#------------------------------------------------------------------------
function VALIDATE_DATES
{
#\
# This function will validate the given date range in SQL*Plus, as there are no native date checking
# routines available at the .ksh level.
#/
	echo "$SQLPLUS_SETTINGS
	ALTER SESSION SET nls_date_format = 'DD-MON-YYYY HH24:MI:SS';

	WHENEVER SQLERROR EXIT 5
	SELECT TO_DATE(NVL('$BEGIN_DATETIME','01-JAN-1900 01:00:00')) FROM dual;

	WHENEVER SQLERROR EXIT 10
	SELECT TO_DATE(NVL('$END_DATETIME',TRUNC(sysdate-${SAVE_DAYS}))) FROM dual;

	WHENEVER SQLERROR EXIT 15
	SELECT 1/DECODE(SIGN(TO_DATE(NVL('$END_DATETIME',TRUNC(sysdate-${SAVE_DAYS}))) - TO_DATE(NVL('$BEGIN_DATETIME','01-JAN-1900 01:00:00'))),0,0,-1,0,1) FROM dual;

	EXIT" | sqlplus -s ${STATSPACK_USER}/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.${STATSPACK_USER}) > \
		/tmp/$$.err

	RETURN_STATUS=$?

	if [ "$RETURN_STATUS" = "5" ]; then
	   echo "*** Invalid begin date.  Please use the date format: DD-MON-YYYY HH24:MI:SS."
	   exit -1
	elif [ "$RETURN_STATUS" = "10" ]; then
	   echo "*** Invalid end date.  Please use the date format: DD-MON-YYYY HH24:MI:SS."
	   exit -1
	elif [ "$RETURN_STATUS" = "15" ]; then
	   echo "*** Invalid date range.  Beginning date must be less than Ending date."
	   exit -1
	else
	   cat /tmp/$$.err | while read LINE
	   do
	      if [ $COUNTER -lt 3 ]; then
	         if [ $COUNTER -eq 1 ]; then
	            BEGIN_DATETIME="$LINE"
	            echo "Begin date: $LINE"
	         elif [ $COUNTER -eq 2 ]; then
	            END_DATETIME="$LINE"
	            echo "End date: $LINE"
	         fi
	      fi
	      ((COUNTER=COUNTER+1))
	   done
	fi
	[[ -r /tmp/$$.err ]] && rm /tmp/$$.err
}

#------------------------------------------------------------------------
function GET_SNAP_IDS
{
#\
# This function will determine the lo and hi snapids for the given date range.  This is necessary as sppurge.sql
# works only off the snapids.
#/
	COUNTER=1
	echo "$SQLPLUS_SETTINGS
	ALTER SESSION SET nls_date_format = 'DD-MON-YYYY HH24:MI:SS';
	SELECT MIN(snap_id) FROM stats\$snapshot WHERE snap_time >= TO_DATE('$BEGIN_DATETIME');
	SELECT MAX(snap_id) FROM stats\$snapshot WHERE snap_time <= TO_DATE('$END_DATETIME');
	SELECT 'Min possible begin date: '||TO_CHAR(MIN(snap_time))||', Max possible end date: '||TO_CHAR(MAX(snap_time)) 
	  FROM stats\$snapshot; 
	EXIT" | sqlplus -s ${STATSPACK_USER}/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.${STATSPACK_USER}) |
	while read LINE
	do
	   if [ -n "$LINE" ]; then
	      if [ $COUNTER -eq 1 ]; then
	         BEGIN_SNAPID="$LINE"
	      elif [ $COUNTER -eq 2 ]; then
	         END_SNAPID="$LINE"
	      else
	         echo "$LINE"
	      fi
	   fi
	   ((COUNTER=COUNTER+1))
	done
}

#------------------------------------------------------------------------
function STOP_JOB
{
#\
# This function will select relevant information about the current statspack job, save it for 
# resubmission later, then stop the job so the purge runs properly.  The first SELECT is for
# audit trail information.
#/
	echo "set linesize 132
	SELECT * FROM user_jobs WHERE what = 'statspack.snap;';
	EXIT" | sqlplus -s ${STATSPACK_USER}/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.${STATSPACK_USER})

	echo "$SQLPLUS_SETTINGS
	SELECT job, interval, instance FROM user_jobs WHERE what = 'statspack.snap;';
	EXIT" | sqlplus -s ${STATSPACK_USER}/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.${STATSPACK_USER}) |
        while read FIELD1 FIELD2 FIELD3 REST
        do
           if [ -n "$FIELD1" ]; then 
	      STOP_JOBID="$FIELD1"
	      SP_NEXT_DATE="$FIELD2"
	      SP_INTERVAL=$(echo $SP_NEXT_DATE | sed s"/'/''/g")
	      SP_INSTANCE="$FIELD3"
	   fi
        done

#\
# Stop the job if it's running.
#/
	if [ -n "$STOP_JOBID" ]; then
	   echo "EXECUTE dbms_job.remove(job => $STOP_JOBID);
	   COMMIT;
	   EXIT" | sqlplus -s ${STATSPACK_USER}/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.${STATSPACK_USER})
	fi
}

#--------------------------------------------------------------------------
function RUN_PURGE
{
	echo "define losnapid=$BEGIN_SNAPID
	define hisnapid=$END_SNAPID
	@$ORACLE_HOME/rdbms/admin/sppurge
	EXIT" | sqlplus -s ${STATSPACK_USER}/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.${STATSPACK_USER})
}

#--------------------------------------------------------------------------
function START_JOB
{
#\
# This function will restart the collection job as PERFSTAT.
#/
	echo "set linesize 132
	VARIABLE jobno NUMBER;
	EXECUTE DBMS_JOB.SUBMIT(job => :jobno, what => 'statspack.snap;', next_date => $SP_NEXT_DATE, interval => '$SP_INTERVAL', no_parse => TRUE, instance => $SP_INSTANCE, force => FALSE);

	SELECT * FROM user_jobs WHERE what = 'statspack.snap;';
	EXIT" | sqlplus -s ${STATSPACK_USER}/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.${STATSPACK_USER})
}

#--------------------------------------------------------------------------
while getopts "b:e:" OPT
do
   case $OPT in
      b ) BEGIN_DATETIME=$OPTARG;;
      e ) END_DATETIME=$OPTARG;;
      \?) USAGE;;
      * ) USAGE;;
   esac
done

VALIDATE_DATES
GET_SNAP_IDS

#\
# If the END_SNAPID is NULL, then there is no data earlier than the upper (or latest) bound of the
# date, so no data is old enough to be purged.
#/
if [ -n "$END_SNAPID" ]; then
   STOP_JOB
   RUN_PURGE
   [[ -n "$STOP_JOBID" ]] && START_JOB
else
   echo "No data to purge within given date range."
fi
