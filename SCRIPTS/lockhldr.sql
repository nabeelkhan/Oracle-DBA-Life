REM FILE NAME:  lockhldr.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   To observe the blocking user sessions and the 
REM             waiting user sessions all in a single statement
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   all_objects, v$session, v$lock, v$session, v$lock
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET FEEDBACK OFF VERIFY OFF 
SET lines 132 pages 59
TTITLE 'User Blocking and Waiting for Other Users'
SPOOL rep_out\lockhldr
SELECT DISTINCT o.object_name,    sh.username
                               || '('
                               || sh.sid
                               || ')' "Holder",
                   sw.username
                || '('
                || sw.sid
                || ')' "Waiter",
                DECODE (
                   lh.lmode,
                   1, 'NULL',
                   2, 'row share',
                   3, 'row exclusive',
                   4, 'share',
                   5, 'share row exclusive',
                   6, 'exclusive'
                ) "Lock Type"
           FROM all_objects o, v$session sw, v$lock lw, v$session sh, v$lock lh
          WHERE lh.id1 = o.object_id
            AND lh.id1 = lw.id1
            AND sh.sid = lh.sid
            AND sw.sid = lw.sid
            AND sh.lockwait IS NULL
            AND sw.lockwait IS NOT NULL
            AND lh.TYPE = 'TM'
            AND lw.TYPE = 'TM'
/
SPOOL off
SET lines 80 pages 22
TTITLE off
CLEAR columns
