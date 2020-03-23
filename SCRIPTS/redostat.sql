REM FILE NAME:  redostat.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Report on Redo log statistics
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$waitstat
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


START title80 "Redo Log Statistics"
SPOOL rep_out\redostat
SELECT   CLASS, COUNT
    FROM v$waitstat
   WHERE CLASS IN ('free list',
                   'system undo header',
                   'system undo block',
                   'undo header',
                   'undo block'
                  )
ORDER BY CLASS
/
SPOOL off
TTITLE OFF
