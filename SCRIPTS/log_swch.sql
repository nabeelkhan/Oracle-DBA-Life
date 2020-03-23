REM FILE NAME:  log_swch.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Provide info on logs for last 24 hour since last log switch
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$log_history, v$archived_log
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN thread#          format 999      heading 'Thrd#'
COLUMN sequence#        format 99999    heading 'Seq#'
COLUMN first_change#                    heading 'SCN Low#'
COLUMN next_change#                     heading 'SCN High#'
COLUMN archive_name     format a50      heading 'Log File'
COLUMN first_time       format a20      heading 'Switch Time'
COLUMN name             format a30      heading 'Archive Log'
SET lines 132
@title132 "Log Switch History Report"
SPOOL rep_out\log_swch
REM
SELECT a.recid, a.thread#, a.sequence#, a.first_change#, a.next_change#,
       TO_CHAR (a.first_time, 'DD-MON-YYYY HH24:MI:SS') first_time, x.NAME
  FROM v$log_history a, v$archived_log x
 WHERE a.first_time > (SELECT   b.first_time
                              - 1
                         FROM v$log_history b
                        WHERE b.next_change# = (SELECT MAX (c.next_change#)
                                                  FROM v$log_history c))
   AND a.recid = x.sequence#(+);
SPOOL off
SET lines 80 
CLEAR columns 
TTITLE off
