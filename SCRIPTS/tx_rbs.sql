REM FILE NAME:  tx_rbs.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Generate a report of active rollbacks
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$lock,v$process,v$rollname
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN  name    format a20              heading "Rollback Segment Name"
COLUMN  pid     format 9999999999       heading "Oracle PID"
COLUMN  spid    format 9999999999       heading "Sys PID"
SET pages 56  lines 130 verify off feedback off
START title132 "Rollback Segments in Use"
SPOOL rep_out\tx_rbs
SELECT   r.NAME, l.sid, p.spid, NVL (p.username, 'no transaction') "Transaction",
         p.terminal "Terminal"
    FROM v$lock l, v$process p, v$rollname r
   WHERE l.sid = p.pid(+)
     AND TRUNC (l.id1(+) / 65536) = r.usn
     AND l.TYPE(+) = 'TX'
     AND l.lmode(+) = 6
ORDER BY R.NAME;
SPOOL off
SET pages 22  lines 80 verify on feedback on
CLEAR columns
TTITLE off
