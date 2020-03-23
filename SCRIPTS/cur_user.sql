REM FILE NAME:  cur_user.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Provide listing of currently active users 
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$session
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


START title80 "DATABASE CURRENT USERS REPORT"
SPOOL rep_out\cur_user
COLUMN username format a30 heading 'USERNAME'
COLUMN count(*) format 999 heading '# OF LOGINS'
SELECT   NVL (username, 'SYS') username, COUNT (*)
    FROM v$session
GROUP BY username
ORDER BY username;
SPOOL off
CLEAR columns
TTITLE off
