REM FILE NAME:  db_snp.sql
REM LOCATION:   Object Management\Snapshot and Snapshot Log Reports
REM FUNCTION:   Report on database Snapshots
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_snapshots
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET pages 56 lines 130 feedback on echo off
REM
COLUMN owner    format a10      heading "Owner"
COLUMN snapshot format a30      heading "Snapshot"
COLUMN source   format a30      heading "Source Table"
COLUMN link     format a20      heading "Link"
COLUMN log                      heading "Use Log?"
COLUMN refreshed                heading "Refreshed?"
COLUMN error    format a20      heading "Error?"
COLUMN type     format a10      heading "Refresh Type"
COLUMN refreshed                heading "Last Refresh"
COLUMN started  format a13      heading "Start Refresh"
COLUMN error                    heading "Error"
COLUMN type                     heading "Type Refresh"
COLUMN next     format a13      heading "Next Refresh"
REM
START title132 "Snapshot Report"
SPOOL rep_out\db_snp
REM
SELECT   owner,    NAME
                || '.'
                || table_name SNAPSHOT, master_view,
            master_owner
         || '.'
         || MASTER SOURCE, master_link LINK,
         can_use_log LOG, last_refresh refreshed, start_with started, error,
         TYPE, NEXT, QUERY
    FROM dba_snapshots
ORDER BY 1, 3, 5;
REM
SPOOL off
SET pages 22 lines 80 feedback on
CLEAR columns
TTITLE off
