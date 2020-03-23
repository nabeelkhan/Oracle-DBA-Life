REM FILE NAME:  dd_cache.sql
REM LOCATION:   Database Tuning\Shared Pool Reports
REM FUNCTION:   Generate report to show Data Dictionary cache condition
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$rowcache
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM SET FLUSH OFF
REM SET TERM OFF


SET PAGESIZE 59
SET LINESIZE 79 echo off
COLUMN parameter FORMAT A20
COLUMN type FORMAT a10
COLUMN percent FORMAT 999.99 HEADING "%";
START title80 "DATA DICTIONARY CACHE STATISTICS"
SPOOL rep_out/dd_cache
SELECT   parameter, TYPE, gets, getmisses,
         (getmisses / gets * 100) PERCENT, COUNT, usage
    FROM v$rowcache
   WHERE gets > 100 AND getmisses > 0
ORDER BY parameter;
SPOOL OFF
