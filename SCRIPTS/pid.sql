REM FILE NAME:  pid.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Generate a list of current oracle sids/pids
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$session, v$process
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN program format a25
COLUMN pid format 9999
COLUMN sid format 9999
COLUMN osuser heading Operating|system|User
SET lines 132
BREAK on username 
COMPUTE count of pid on username
SET pages 58
START title132 "Oracle Processes"
SPOOL rep_out\pid
SELECT   NVL (a.username, 'Null') username, b.pid, a.sid,
         DECODE (a.terminal, '?', 'Detached', a.terminal) terminal, b.program,
         b.spid, a.osuser, a.serial#
    FROM v$session a, v$process b
   WHERE a.paddr = b.addr
ORDER BY A.username, b.pid
/
SPOOL off
CLEAR breaks
CLEAR columns
SET pages 22
TTITLE off
