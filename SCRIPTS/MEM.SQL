REM FILE NAME:  mem.sql
REM LOCATION:   Application Tuning\Reports
REM FUNCTION:   Generate value for current session memory usage
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$session, v$sesstat, v$statname
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


@title132 'Current Session Memory'
SPOOL rep_out/mem
SELECT   NVL (username, 'SYS-BKGD') username, sess.sid,
            SUM (VALUE)
         || ' bytes' "Current session memory"
    FROM v$session sess, v$sesstat stat, v$statname NAME
   WHERE sess.sid = stat.sid
     AND stat.statistic# = NAME.statistic#
     AND NAME.NAME LIKE 'session % memory'
GROUP BY username, sess.sid
/
SPOOL off
TTITLE off
