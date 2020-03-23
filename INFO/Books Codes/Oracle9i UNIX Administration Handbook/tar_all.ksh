#!/bin/ksh

echo Start `date` > /usr/local/bin/scripts/logs/tar_start.lst

#**********************************************
# Mount the tape and rewind
#**********************************************
mt -f /dev/rmt/2m rew

#**********************************************
# Copy directories onto /dev/rmt/2m
#**********************************************
tar cvf /dev/rmt/2m /u03/oradata/PROD /u04/oradata/PROD /u01/oradata/PROD /u02/oradata/PROD /u01/app/oracle/admin/PROD/arch /u02/oradata/TEST /u03/oradata/TEST /u02/app/applmgr/1103/PROD /u01/app/oracle/product/8.0.5 /u01/app/oracle/admin/PROD/arch

echo End `date` > /usr/local/bin/scripts/logs/tar_end.lst
