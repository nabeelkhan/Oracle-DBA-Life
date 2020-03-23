REM FILE NAME:  login_tm.sql
REM LOCATION:   Security Administration\Reports
REM FUNCTION:   Report user login times. (requires timed_statistics.)
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.V_$sesstat, sys.V_$session, sys.v_$timer
REM REQUIRES:   timed_statistics=true
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN sids       format a10   heading "Sid,Ser#"
COLUMN username   format a15   heading Username
COLUMN ltime      format a20   heading "Login Time"
COLUMN program    format a30   heading Program
START title80 'User Login Times'
SPOOL rep_out\login_tm
SELECT      s.sid
         || ','
         || n.serial# sids, n.username, n.status "Status",
         n.program,
         TO_CHAR (
              SYSDATE
            - (  hsecs
               - s.VALUE
              ) / (24 * 3600 * 100),
            'MM/DD/YYYY HH24:MI:SS'
         ) ltime
    FROM sys.v_$sesstat s, sys.v_$session n, sys.v_$timer
   WHERE s.statistic# = 13 AND s.sid = n.sid
ORDER BY 2, 5;
SPOOL off
TTITLE off
