REM FILE NAME:  redo_grp.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   report on redo log groups and their status
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$logfile
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN member format a60
SET pages 79
@title80 "Redo Log Group Report"
SPOOL rep_out\redo_grp
SELECT   *
    FROM v$logfile
ORDER BY group#;
SPOOL OFF
TTITLE OFF
