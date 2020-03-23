REM FILE NAME:  db_links.sql
REM LOCATION:   Object Management\Database Link
REM FUNCTION:   Generate report of database links.
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_db_links
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET pages 58 lines 130 verify off term off
START title132 "Db Links Report"
SPOOL rep_out\db_links
COLUMN host             format a60      heading "Connect String Used"
COLUMN owner            format a15      heading "Creator of DB Link"
COLUMN db_link          format a10      heading "DB Link Name" 
COLUMN username         format a15      heading "Connecting User"
COLUMN password         format a15      heading "Password"
COLUMN create                           heading "Date Created" 
SELECT   host, owner, db_link, username, created
    FROM dba_db_links
ORDER BY owner, HOST;
SPOOL off
SET pages 22 lines 80 verify on termout on
TTITLE off
CLEAR columns
