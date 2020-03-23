REM FILE NAME:  events.sql
REM LOCATION:   Security Administration\Reports
REM FUNCTION:   Generate a report on session events by user
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.v_$session_event, sys.v_$session 
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN sid              HEADING Sid
COLUMN event            HEADING Event            FORMAT a40
COLUMN total_waits      HEADING Total|Waits
COLUMN total_timeouts   HEADING Total|Timeouts
COLUMN time_waited      HEADING Time|Waited
COLUMN average_wait     HEADING Average|Wait
COLUMN username         HEADING User
BREAK ON username
START title132 "Session Events By User"
SPOOL rep_out\events
SET LINES 132 PAGES 59
SELECT   username, event, total_waits, total_timeouts, time_waited,
         average_wait
    FROM sys.v_$session_event a, sys.v_$session b
   WHERE a.sid = b.sid
ORDER BY 1;
SPOOL OFF
CLEAR COLUMNS
CLEAR BREAKS
SET LINES 80 PAGES 22
TTITLE OFF
