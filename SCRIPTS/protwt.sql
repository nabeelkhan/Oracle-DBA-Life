REM FILE NAME:  protwt.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Show average wait time for MTS
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$queue, v$dispatcher
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN protocol                                 format a55
COLUMN "Average Wait Time per Response"         format a40 
REM
SET echo off
SPOOL rep_out\protwt
START TITLE132 'Average Wait Time for MTS'
SELECT   network "Protocol",
         DECODE (
            SUM (totalq),
            0, 'No Responses',
               SUM (wait) / SUM (totalq)
            || ' hundredths of seconds'
         ) "Average Wait Time per Response"
    FROM v$queue q, v$dispatcher d
   WHERE q.TYPE = 'DISPATCHER' AND q.paddr = d.paddr
GROUP BY network
/
SPOOL OFF
CLEAR columns
TTITLE OFF
