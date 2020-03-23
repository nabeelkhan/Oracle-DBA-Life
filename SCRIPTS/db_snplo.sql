REM FILE NAME:  db_snplo.sql
REM LOCATION:   Object Management\Snapshot and Snapshot Log Reports
REM FUNCTION    Report on database Snapshot Logs
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_snapshot_logs
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET pages 56 lines 130 feedback off echo off
START title132 "Snapshot Log Report"
SPOOL rep_out\db_snplo
REM
COLUMN log_owner        format a10      heading "Owner"
COLUMN master           format a20      heading "Master"
COLUMN log_table        format a20      heading "Snapshot"
COLUMN log_trigger      format a20      heading "Trigger Name"
COLUMN current_snapshots                heading "Last Refresh"
REM
SELECT   log_owner, MASTER, log_table, log_trigger, current_snapshots
    FROM dba_snapshot_logs
ORDER BY 1;
REM
SPOOL off
SET pages 22 lines 80 feedback on
CLEAR columns
TTITLE off
