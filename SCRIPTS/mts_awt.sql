REM FILE NAME:  mts_awt.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Generate Average wait time report for dispatchers
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$queue
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN awt FORMAT A30 HEADING 'Average Wait Time per Request'
SET FEEDBACK OFF VERIFY OFF LINES 78 PAGES 58
START title80 'Dispatcher Average Wait Time'
SPOOL rep_out\mts_awt
SELECT DECODE (
          totalq,
          0, 'No Requests',
             (wait / totalq) * 100
          || 'Seconds Request Wait'
       ) awt
  FROM v$queue
 WHERE TYPE = 'COMMON';
SPOOL OFF
SET FEEDBACK ON VERIFY ON LINES 80 PAGES 22
TTITLE off
