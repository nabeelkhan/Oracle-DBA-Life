#!/bin/ksh
#--------------------------------------------------------------------------
# StatspackCleanup.ksh
#
#    This script is used to cleanup old StatsPack statistics.  It accepts a
# start and end date range.  If none is supplied, it will default to deleting
# all statistics older than 1 week.
#
# Assumptions:
#    Security is handled by storing passwords for Oracle accounts in a 
# directory within the OFA structure.  These password files are hidden files
# with protection set for only DBA group access.
#
# Arguments:
#	-b <date>	Begin date, in 'DD-MON-YYYY HH24:MI:SS' format.  Default
#			is 01-JAN-1900.
#	-e <date>	End date, in 'DD-MON-YYYY HH24:MI:SS' format.  Default
#			is TODAY-7.
#
#--------------------------------------------------------------------------

SAVE_PERIOD=7
SQLPLUS_SETTINGS="set echo off feedback off heading off pagesize 0 tab off termout off"
THISFILE=$(basename $0)

#------------------------------------------------------------------------
function USAGE
{
	echo "$THISFILE -b <Begin datetime> -e <End datetime>"
	exit -1
}

#------------------------------------------------------------------------
function STOP_JOB
{
	echo "
	select * from user_jobs;

	$SQLPLUS_SETTINGS
	select job from user_jobs;
	exit" | sqlplus -s perfstat/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.perfstat) |
        while read LINE
        do
           if [ -n "$LINE" ]; then
              STOP_JOBID="$LINE"
           fi
        done

	echo "execute dbms_job.remove($STOP_JOBID);
	commit;
	exit" | sqlplus -s perfstat/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.perfstat)
}

#------------------------------------------------------------------------
function VALIDATE_DATES
{
#\
# If the starting date is null, choose 01-Jan-1900 01:00:00, which should be more than
# early enough.
#/
	if [ -z "$BEGIN_DATETIME" ]; then
	   BEGIN_DATETIME="01-JAN-1900 01:00:00"
	fi

#\
# If the ending date is null, choose 1 week ago today, at 01:00:00.
#/
	if [ -z "$END_DATETIME" ]; then
	   echo "$SQLPLUS_SETTINGS
	   select to_char(trunc(sysdate-${SAVE_PERIOD}),'DD-MON-YYYY HH24:MI:SS') from dual;
	   exit" | sqlplus -s perfstat/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.perfstat) |
	   while read LINE
	   do
	      if [ -n "$LINE" ]; then
	         END_DATETIME="$LINE"
	      fi
	   done
	fi

#\
# Use Oracle's to_date function to validate both dates.
#/
	echo "$SQLPLUS_SETTINGS
	select to_date('${BEGIN_DATETIME}','DD-MON-YYYY HH24:MI:SS') from dual;
	exit" | sqlplus -s perfstat/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.perfstat) |
	while read LINE
	do
	   FIRST_WORD=$(echo $LINE | awk '{print substr($0,0,3)}')
	   if [ "$FIRST_WORD" = "ORA" ]; then
	      echo "Invalid begin date.  Please use the date format: DD-MON-YYYY HH24:MI:SS."
	      exit -1
	   fi
	done

	echo "$SQLPLUS_SETTINGS
	select to_date('${END_DATETIME}','DD-MON-YYYY HH24:MI:SS') from dual;
	exit" | sqlplus -s perfstat/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.perfstat) |
	while read LINE
	do
	   FIRST_WORD=$(echo $LINE | awk '{print substr($0,0,3)}')
	   if [ "$FIRST_WORD" = "ORA" ]; then
	      echo "Invalid end date.  Please use the date format: DD-MON-YYYY HH24:MI:SS."
	      exit -1
	   fi
	done
}

#------------------------------------------------------------------------
function GET_SNAP_IDS
{
#\
# First determine the snap_id of the lower bound of the date range.
#/
	echo "$SQLPLUS_SETTINGS
	alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';
	select min(snap_id) from stats\$snapshot
	where snap_time >= to_date('$BEGIN_DATETIME');
	exit" | sqlplus -s perfstat/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.perfstat) |
	while read LINE
	do
	   if [ -n "$LINE" ]; then
	      BEGIN_SNAPID="$LINE"
	   fi
	done

#\
# Next determine the snap_id of the upper bound of the date range.
#/
	echo "$SQLPLUS_SETTINGS
	alter session set nls_date_format = 'DD-MON-YYYY HH24:MI:SS';
	select max(snap_id) from stats\$snapshot
	where snap_time <= to_date('$END_DATETIME');
	exit" | sqlplus -s perfstat/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.perfstat) |
	while read LINE
	do
	   if [ -n "$LINE" ]; then
	      END_SNAPID="$LINE"
	   fi
	done
}

#--------------------------------------------------------------------------
function RUN_PURGE
{
	echo "Begin snapid: $BEGIN_SNAPID, end snapid: $END_SNAPID, Begin date: $BEGIN_DATETIME, End date: $END_DATETIME"
	echo "
	define losnapid=$BEGIN_SNAPID
	define hisnapid=$END_SNAPID
	@$ORACLE_HOME/rdbms/admin/sppurge
	exit" | sqlplus perfstat/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.perfstat)
}

#--------------------------------------------------------------------------
function START_JOB
{
#\
# This function will restart the collection job, as PERFSTAT.
#/
	echo "set echo on feedback on serveroutput on timing on
	select * from user_jobs;

	variable jobno number;
	variable instno number;
	begin
	   select instance_number into :instno from v\$instance;
	   dbms_job.submit(:jobno, 'statspack.snap;', trunc(sysdate+1/48,'HH'), 'trunc(SYSDATE+1/24,''HH'')', TRUE, :instno);
	   commit;
	end;
/

	select * from user_jobs;

	exit" | sqlplus perfstat/$(cat ${ORACLE_BASE}/admin/${ORACLE_SID}/security/.perfstat)
}

#--------------------------------------------------------------------------
while getopts "b:e:" OPT
do
   case $OPT in
      b ) START_DATETIME=$OPTARG;;
      e ) END_DATETIME=$OPTARG;;
      \?) USAGE;;
      * ) USAGE;;
   esac
done

STOP_JOB
VALIDATE_DATES
GET_SNAP_IDS
RUN_PURGE
START_JOB
