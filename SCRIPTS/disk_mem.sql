REM FILE NAME: 	disk_mem.sql 
REM LOCATION:  	Database Tuning\Disk Sort Reports
REM FUNCTION:  	Disk to memory sorts percent 
REM FUNCTION:
REM TESTED ON:  8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET pages 0 lines 80 echo off
START title80 'Disk to Memory Sorts Percent'
SPOOL rep_out/disk_mem
TTITLE off
SET pages 0 lines 80 heading off
SELECT      'Disk to memory Sorts percent'
         || ','
         || TO_CHAR (
               (a.VALUE / b.VALUE) * 100,
               999.9999
            )
         || ','
         || TO_CHAR (a.meas_date, 'dd-mon-yy hh24:mi')
    FROM dba_running_stats a, dba_running_stats b
   WHERE a.NAME = 'sorts (disk)'
     AND b.NAME = 'sorts (memory)'
     AND a.meas_date = b.meas_date
     AND TRUNC (a.meas_date) >= TO_DATE ('&dd_mon_yy', 'dd-mon-yy')
ORDER BY A.meas_date
/
SPOOL off
