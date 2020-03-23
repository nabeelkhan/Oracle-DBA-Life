REM FILE NAME:  latch_co.sql
REM LOCATION:   Database Tuning\Contention Reports
REM FUNCTION:   Genereate latch contention report
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   V$LATCHNAME , V$LATCH
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN NAME   FORMAT A30
COLUMN RATIO1  FORMAT 999.9999
COLUMN RATIO2  FORMAT 999.9999
SET PAGES 58 NEWPAGE 0
START title80 "LATCH CONTENTION REPORT"
SPOOL rep_out\ltch7_co
SELECT a.NAME, 100. * b.sleeps / b.gets ratio1,
         100.
       * b.immediate_misses
       / DECODE ((  b.immediate_misses
                  + b.immediate_gets
                 ), 0, 1) ratio2
  FROM v$latchname a, v$latch b
 WHERE a.latch# = b.latch# AND b.sleeps > 0;
SPOOL OFF
CLEAR columns
TTITLE off
SET pages 22
