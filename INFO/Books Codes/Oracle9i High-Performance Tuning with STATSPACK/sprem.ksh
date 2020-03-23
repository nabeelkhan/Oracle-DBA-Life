#!/bin/ksh

# **********************************************
# 
#  This will purge the 168 oldest snapshots
#  (7 oldest days worth @ one spapshot per hour)
# 
#  This should be cronned weekly
# 
#  sample crontab entry
# 
#  00 7 1 * * /export/home/oracle/sprem.ksh MYSID > /export/home/r.lst
# 
#   4/3/01 By Donald K. Burleson
# 
# **********************************************

# First, we must set the environment . . . .
ORACLE_SID=$ORACLE_SID
export ORACLE_SID
#ORACLE_HOME=`cat /etc/oratab|grep ^$ORACLE_SID:|cut -f2 -d':'`
ORACLE_HOME=`cat /var/opt/oracle/oratab|grep ^$ORACLE_SID:|cut -f2 -d':'`
export ORACLE_HOME
PATH=$ORACLE_HOME/bin:$PATH
export PATH

for i in `echo 1 2 3 4 5 6 7`  # This is to spare the rollback segs
do
$ORACLE_HOME/bin/sqlplus -s perfstat/perfstat<<!

select min(snap_id) + 24
   from
      perfstat.stats\$snapshot;


delete from
   perfstat.stats\$snapshot
where
  snap_id <
  (select 
      min(snap_id)+24
   from
      perfstat.stats\$snapshot)
;
commit;
exit
!
done
