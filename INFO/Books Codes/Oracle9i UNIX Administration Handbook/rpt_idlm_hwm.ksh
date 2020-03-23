#! /bin/ksh
# Display high-water mark of IDLM
# Donald K. Burleson
# get the max values . . . . 

#grep ^lkmgr_args /oracle/HOME/ops/HOME.conf
 
MAX_LOC=`grep ^lkmgr_args /oracle/HOME/ops/HOME.conf|cut -f6 -d ' '`
MAX_RES=`grep ^lkmgr_args /oracle/HOME/ops/HOME.conf|cut -f8 -d ' '`
MAX_PRO=`grep ^lkmgr_args /oracle/HOME/ops/HOME.conf|cut -f10 -d ' '|sed -e 's/"//
'`

ORACLE_SID=HOME; export ORACLE_SID;
PATH=$PATH:/oracle/HOME/bin; export PATH;
ORACLE_HOME=/oracle/HOME; export ORACLE_HOME;

unalias rm
rm -f *.tmp

/oracle/HOME/bin/sqlplus <<! > /dev/null

connect perfstat/perfstat;

set newpage 0;
set space 0
set pages 0
set termout off
set feedback off
set echo off
set heading off

spool pro
select max(processes) from perfstat.stats$dlm_stats;
spool res
select max(resources) from perfstat.stats$dlm_stats;
spool loc
select max(locks) from perfstat.stats$dlm_stats;
spool off
exit
!

PRO=`grep '^  ' pro.lst|awk '{print $1}'`

RES=`grep '^  ' res.lst|awk '{print $1}'`

LOC=`grep '^  ' loc.lst|awk '{print $1}'`

# Now the fun part . . . . 

PCT_PRO=`expr $PRO \* 100 \/ $MAX_PRO`
echo "IDLM Process high-water mark is $PRO, or $PCT_PRO percent of max val of $MAX_PRO"

PCT_RES=`expr $RES \* 100 \/ $MAX_RES`
echo "IDLM Resource high-water mark is $RES, or $PCT_RES percent of max val of $MAX_RES"

PCT_LOC=`expr $LOC \* 100 \/ $MAX_LOC`
echo "IDLM Locks high-water mark is $LOC, or $PCT_LOC percent of max val of $MAX_LOC"

