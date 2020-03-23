REM FILE NAME: 	sorts_disk.sql 
REM LOCATION:   Database Tuning\Disk Sort Reports
REM FUNCTION:   Disk sort activities  
REM  FUNCTION:
REM TESTED ON:  8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM

COLUMN value format 999.9999
COLUMN name format a25
COLUMN meas_date format a16
SET pages 0 lines 80
START title80 'Disk Sort Activity'
SPOOL rep_out/sorts_disk
SELECT   NAME, VALUE, delta, TO_CHAR (meas_date, 'dd-mon-yy hh24:mi') meas_date
    FROM dba_running_stats
   WHERE NAME = 'sorts (disk)'
     AND TRUNC (meas_date) > TO_DATE ('&dd_mon_yy', 'dd-mon-yy')
ORDER BY meas_date
/
SPOOL off
