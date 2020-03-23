REM FILE NAME:  open_cur.sql
REM LOCATION:   Database Tuning\Shared Pool Reports
REM FUNCTION:   Provide a count of open cursors per user
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.v_$open_cursor
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN user_name    heading User
COLUMN num          heading Number|Of|Cursors
SET echo off
START title80 'Open Cursors By User'
SET lines 80 pages 59
SPOOL rep_out\open_cur
SELECT   user_name, COUNT (*) num
    FROM sys.v_$open_cursor
GROUP BY user_name;
SPOOL off
CLEAR columns
TTITLE off
SET pages 22
