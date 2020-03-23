REM FILE NAME:  mts_disp.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Generate percent busy report for dispatchers
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$dispatcher
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN protocol FORMAT A50      HEADING 'Dispatcher Protocol'
COLUMN busy     FORMAT 999.99  HEADING 'Percent|Busy'
SET FEEDBACK OFF VERIFY OFF LINES 78 PAGES 58
START title80 'Dispatcher Status'
SPOOL rep_out\mts_disp
SELECT   network protocol,
           (SUM (busy) / (  SUM (busy)
                          + SUM (idle)
                         )
           )
         * 100 busy
    FROM v$dispatcher
GROUP BY network;
SPOOL OFF
SET FEEDBACK ON VERIFY ON
TTITLE OFF
