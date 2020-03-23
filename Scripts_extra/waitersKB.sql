REM FILE NAME:  waiters.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Report on sessions waiting for locks
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.v_$session, sys.dba_waiters, sys.v_$session
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN busername             FORMAT a10      HEADING 'Holding|User'
COLUMN wusername             FORMAT a10      HEADING 'Waiting|User'
COLUMN bsession_id                           HEADING 'Holding|SID'
COLUMN wsession_id                           HEADING 'Waiting|SID'
COLUMN mode_held             FORMAT a20      HEADING 'Mode|Held'
COLUMN mode_requested        FORMAT a20      HEADING 'Mode|Requested'
COLUMN lock_id1              FORMAT a20      HEADING 'Lock|ID1'
COLUMN lock_id2              FORMAT a20      HEADING 'Lock|ID2'
COLUMN type                                  HEADING 'Lock|Type'
SET LINES 132 PAGES 59 FEEDBACK OFF ECHO OFF
START title132 'Processes Waiting on Locks Report'
SPOOL rep_out/waiters
SELECT holding_session bsession_id, waiting_session wsession_id,
       b.username busername, a.username wusername, c.lock_type TYPE, mode_held,
       mode_requested, lock_id1, lock_id2
  FROM sys.v_$session b, sys.dba_waiters c, sys.v_$session a
 WHERE c.holding_session = b.sid AND c.waiting_session = a.sid
/
SPOOL OFF
CLEAR COLUMNS
SET LINES 80 PAGES 22 FEEDBACK ON 
TTITLE OFF
