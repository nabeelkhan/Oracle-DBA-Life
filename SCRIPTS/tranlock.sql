REM FILE NAME:  tranlock.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Report on transacations experiencing lock contention.
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$lock
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM 
REM NOTES:   To obtain more information on the type of lock being held.
REM          The id1 column in the V$LOCK table is the OBJECT_ID of the
REM          object being locked. The OBJECT_ID can be used to search 
REM          the DBA_OBJECTS table to determine the object and the 
REM          object's owner.
REM
REM***********************************************************************************


SET pages 48 lines 80 feedback off verify off
SPOOL rep_out/tranlock
TTITLE 'Transactions Experiencing Lock Contention'
SELECT DECODE (
          l1.lmode,
          2, 'Row-S(SS)',
          3, 'Row-X(SX)',
          4, 'Share',
          5, 'S/Row-X(SSX)',
          6, 'Exclusive',
          'Other'
       ) mode_held,
       DECODE (
          l1.request,
          2, 'Row-S(SS)',
          3, 'Row-X(SX)',
          4, 'Share',
          5, 'S/Row-X(SSX)',
          6, 'Exclusive',
          'Other'
       ) lock_requested,
       l1.id1, l1.id2
  FROM v$lock l1
 WHERE TYPE = 'TX'
   AND (l1.id1, l1.id2) IN (SELECT l2.id1, l2.id2
                              FROM v$lock l2
                             WHERE l1.id1 = l2.id1
                               AND l1.id2 = l2.id2
                               AND l2.request > 0);
SPOOL off
SET pages 22 lines 80 feedback on verify on
CLEAR columns
TTITLE off
