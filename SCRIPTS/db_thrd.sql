REM FILE NAME:  db_thrd.sql
REM LOCATION:   Object Management\Redo Log Reports
REM FUNCTION:   Provide data on Redo Log Threads
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$thread
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN current_group#       heading Current|Group#
COLUMN Checkpoint_change#   heading Checkpoint|Change#
COLUMN checkpoint_time      heading Checkpoint|Time
COLUMN open_time            heading Open|Time
COLUMN thread#              heading Thread#
COLUMN status               heading Status
COLUMN enabled              heading Enabled
COLUMN groups               heading Groups
COLUMN Instance             heading Instance
COLUMN sequence#            heading Sequence#
SET lines 132 pages 59
START title132 'Redo Thread Report'
SPOOL rep_out\db_thrd
SELECT   *
    FROM sys.v_$thread
ORDER BY thread#;
SPOOL off
SET lines 80 pages 22
TTITLE off
CLEAR columns
