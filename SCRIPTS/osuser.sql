REM FILE NAME:  osuser.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Provide list of SID, System PID and usernames of
REM             current users
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$session a, v$process b
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN sid              format 9999     heading "SID"
COLUMN spid             format 9999     heading "PID"
COLUMN username         format a30      heading "User Name"
COLUMN osuser           format a30      heading "OS User"
SET FEEDBACK OFF VERIFY OFF 
SET lines 132 pages 59
START title80 'Oracle System Users'
SPOOL rep_out/osuser
SELECT a.sid, b.spid, a.username, a.osuser
  FROM v$session a, v$process b
 WHERE a.paddr = b.addr(+)
/
SPOOL off
TTITLE off
CLEAR columns
