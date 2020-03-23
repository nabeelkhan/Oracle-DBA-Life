REM FILE NAME:  dml_lock.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Document DML locks currently in use
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.dba_dml_locks
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM

COLUMN owner            FORMAT a15      HEADING 'User'
COLUMN session_id                       HEADING 'SID'
COLUMN mode_held        FORMAT a20      HEADING 'Mode|Held'
COLUMN mode_requested   FORMAT a20      HEADING 'Mode|Requested'
SET FEEDBACK OFF ECHO OFF PAGES 59 LINES 131
START title132 'Report on All DML Locks Held'
SPOOL rep_out\dml_lock
SELECT   NVL (owner, 'SYS') owner, session_id, NAME, mode_held, mode_requested
    FROM sys.dba_dml_locks
ORDER BY 2
/
SPOOL OFF
CLEAR COLUMNS
SET FEEDBACK ON PAGES 22 LINES 80
TTITLE OFF
