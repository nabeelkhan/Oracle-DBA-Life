REM FILE NAME:  lockproc.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Obtains operating system process id for each session.
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$process, v$access, v$session
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN users            format a15      heading "User Name / SID"
COLUMN owner            format a15      heading "Owner"
COLUMN object           format a30      heading "Object"
COLUMN lockwait         format a15      heading "Lock Wait"
COLUMN os_process       format a10      heading "PID"
BREAK ON username
SET FEEDBACK OFF VERIFY OFF 
START title132 "Operating System Process ID by Session"
SPOOL rep_out\lockproc
SELECT    ses.username
       || '('
       || ses.sid
       || ')' users, acc.owner owner,
       acc.OBJECT OBJECT, ses.lockwait, prc.spid os_process
  FROM v$process prc, v$access acc, v$session ses
 WHERE prc.addr = ses.paddr AND ses.sid = acc.sid;
REM   AND ses.lockwait IS NOT NULL;
SPOOL off
SET lines 80 pages 22
TTITLE off
CLEAR columns
