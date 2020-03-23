REM FILE NAME:  do_calst.sql
REM LOCATION:   Database Tuning\Database-level Reports
REM FUNCTION:   run the cal_stat.sql procedure and gen report
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dbms_revealnet package
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM

SET PAGES 58
SET NEWPAGE 0
REM SET ECHO OFF
REM set termout off
COLUMN TODAY NEW_VALUE _DATE
EXECUTE  DBMS_REVEALNET.just_statistics;
START TITLE80 "CALCULATED STATISTICS REPORT"
SPOOL rep_out\do_calst
SELECT   NAME, VALUE
    FROM dba_temp
ORDER BY rep_order;
SPOOL OFF
SET pages 22
TTITLE off
UNDEF output
