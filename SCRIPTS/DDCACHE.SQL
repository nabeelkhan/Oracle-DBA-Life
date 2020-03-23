REM FILE NAME:  ddcache.sql
REM LOCATION:  	Database Tuning\Shared Pool Reports
REM FUNCTION:   report on the v$rowcache table
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$rowcache
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET echo off
START title80 "DD Cache Hit Ratio"
SPOOL rep_out\ddcache
SELECT (SUM (getmisses) / SUM (gets)) ratio
  FROM v$rowcache
/
SPOOL off
TTITLE off
