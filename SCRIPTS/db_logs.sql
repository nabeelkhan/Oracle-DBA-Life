REM FILE NAME:  db_logs.sql
REM LOCATION:   Object Management\Redo Log Reports
REM FUNCTION:   Report on Redo Logs Physical files
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.v_$logfile
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN group#  format 999999
COLUMN  member format a50
SET lines 80 pages 60 feedback off verify off
START title80 'Redo Log Physical Files'
BREAK on group#
SPOOL rep_out\db_logs
SELECT   *
    FROM sys.v_$logfile
ORDER BY group#
/
SPOOL off
CLEAR columns
CLEAR breaks
TTITLE off
SET pages 22 feedback on verify on
