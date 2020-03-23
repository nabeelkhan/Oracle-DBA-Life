REM FILE NAME:  int_lock.sql
REM LOCATION:   Database Tuning\Contention Reports
REM FUNCTION:   Document current internal locks
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.dba_lock_internal, sys.v_$session
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN username           FORMAT a10      HEADING 'Lock|Holder'
COLUMN session_id                         HEADING 'User|SID'
COLUMN lock_type          FORMAT a27      HEADING ' Lock Type'
COLUMN mode_held          FORMAT a10      HEADING ' Mode| Held'
COLUMN mode_requested     FORMAT a10      HEADING ' Mode| Requested'
COLUMN lock_id1           FORMAT a30      HEADING ' Lock/Cursor| ID1'
COLUMN lock_id2           FORMAT a10      HEADING ' Lock| ID2'
PROMPT 'ALL is all types or modes'
ACCEPT lock PROMPT 'Enter Desired Lock Type: '
ACCEPT mode PROMPT 'Enter Lock Mode: '
SET LINES 132 PAGES 59 FEEDBACK OFF ECHO OFF VERIFY OFF
BREAK ON username
START title132 'Report on Internal Locks Mode: &mode Type: &lock'
SPOOL rep_out\int_lock
SELECT   NVL (b.username, 'SYS') username, session_id, lock_type, mode_held,
         mode_requested, lock_id1, lock_id2
    FROM sys.dba_lock_internal a, sys.v_$session b
   WHERE UPPER (mode_held) LIKE UPPER ('%&mode%')
      OR UPPER ('&mode') = 'ALL' AND UPPER (lock_type) LIKE UPPER ('%&lock%')
      OR UPPER (mode_held) LIKE UPPER ('%&mode%')
      OR UPPER ('&mode') = 'ALL' AND UPPER ('&lock') = 'ALL' AND a.session_id =
                                                                         b.sid
ORDER BY 1, 2
/
SPOOL OFF
SET LINES 80 PAGES 22 FEEDBACK ON VERIFY ON
CLEAR COLUMNS
CLEAR BREAKS
UNDEF LOCK
UNDEF MODE
