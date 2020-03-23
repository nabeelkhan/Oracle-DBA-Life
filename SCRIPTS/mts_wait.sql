REM FILE NAME:  mts_wait.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Generate wait time report for dispatchers
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$queue, v$dispatcher
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN network FORMAT A50   HEADING 'Protocol'
COLUMN aw      FORMAT A30   HEADING 'Average Wait Time %'
SET FEEDBACK OFF VERIFY OFF LINES 78 PAGES 58
START title132 'Dispatcher Wait Times'
SPOOL rep_out\mts_wait
SELECT   network,
         DECODE (
            SUM (totalq),
            0, 'No responses',
               SUM (wait) / SUM (totalq) * 100
            || 'Seconds Wait Per response'
         ) aw
    FROM v$queue q, v$dispatcher d
   WHERE q.TYPE = 'DISPATCHER' AND q.paddr = d.paddr
GROUP BY network;
SPOOL OFF
SET FEEDBACK ON VERIFY ON
TTITLE OFF
