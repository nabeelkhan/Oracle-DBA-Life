REM FILE NAME:  rbk_wait.sql 
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Rollback waits
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
COLUMN name format a30
COLUMN meas_date format a16
SET pages 0 lines 80
START title80 'Rollback Wait Percent'
SPOOL rep_out/rbk_wait
SELECT   NAME, VALUE, TO_CHAR (meas_date, 'dd-mon-yy hh24:mi') meas_date
    FROM dba_running_stats
   WHERE NAME LIKE 'Rollback Wait%'
ORDER BY meas_date
/
SPOOL off
SET echo off
TTITLE off
