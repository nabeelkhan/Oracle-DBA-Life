REM FILE NAME:  blockers.sql
REM LOCATION:  	System Monitoring\Reports
REM FUNCTION:   Show all processes causing a dead lock
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.v_$session, sys.dba_blockers, sys.dba_locks 
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM 

COLUMN username         FORMAT a10  HEADING 'Holding|User'
COLUMN session_id                   HEADING 'SID'
COLUMN mode_held        FORMAT a20  HEADING 'Mode|Held'
COLUMN mode_requested   FORMAT a20  HEADING 'Mode|Requested'
COLUMN lock_id1         FORMAT a20  HEADING 'Lock|ID1'
COLUMN lock_id2         FORMAT a20  HEADING 'Lock|ID2'
COLUMN type                         HEADING 'Lock|Type'
SET LINES 132 PAGES 59 FEEDBACK OFF ECHO OFF
START title132 'Sessions Blocking Other Sessions Report'
SPOOL rep_out\blockers
SELECT a.session_id, username, TYPE, mode_held, mode_requested, lock_id1,
       lock_id2
  FROM v$session b, dba_blockers c, dba_locks a
 WHERE c.holding_session = a.session_id AND c.holding_session = b.sid
/
CLEAR COLUMNS

