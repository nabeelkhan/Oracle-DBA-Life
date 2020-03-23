REM FILE NAME:  contend.sql
REM LOCATION:   Database Tuning\Contention Reports
REM FUNCTION:   Identifies possible contention for resources in the buffer.
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   V$WAITSTAT 
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET VERIFY OFF FEEDBACK OFF  
SET PAGES 58 
SET LINES 79 
START TITLE80 "AREA OF CONTENTION REPORT" 
SPOOL rep_out\contend
SELECT   CLASS, SUM (COUNT) total_waits, SUM (TIME) total_time
    FROM v$waitstat
GROUP BY CLASS;
SPOOL OFF 
SET verify on feedback on pages 22 lines 80
TTITLE off
