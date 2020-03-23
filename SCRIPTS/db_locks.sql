REM FILE NAME:  db_locks.sql
REM LOCATION:   Database Tuning\Contention Reports
REM FUNCTION:   Report all DB locks
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.v_$session, sys.dba_locks   
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM

COLUMN osuser          format a15     heading 'User'
COLUMN session_id                     heading 'SID'
COLUMN mode_held       format a20     heading 'Mode|Held'
COLUMN mode_requested  format a20     heading 'Mode|Requested'
COLUMN lock_id1        format a10     heading 'Lock|ID1'
COLUMN lock_id2        format a10     heading 'Lock|ID2'
COLUMN type                           heading 'Type|Lock'
SET feedback off echo off pages 59 lines 131
START title132 'Report on All Locks'
SPOOL rep_out\db_locks
SELECT   NVL (a.osuser, 'SYS') osuser, b.session_id, TYPE, mode_held,
         mode_requested, lock_id1, lock_id2
    FROM v$session a, dba_locks b
   WHERE a.sid = b.session_id
ORDER BY 2
/
SPOOL off
CLEAR columns
SET feedback on echo on pages 22 lines 80
