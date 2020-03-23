REM FILE NAME:  log_stat.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Provide a current status for redo logs
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.v_$log
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN thread#       format 9,999             heading 'Thread#'
COLUMN group#        format 9,999             heading 'Group#'
COLUMN sequence#     format 999,999           heading 'Sequence#'
COLUMN bytes         format 9,999,999         heading 'Bytes'
COLUMN members       format 999               heading 'Members'
COLUMN archived      format a4                heading 'Archived?'
COLUMN status        format a15               heading 'Status'
COLUMN first_change# format 999999999999999   heading 'Change#'
COLUMN first_time    format date              heading 'First Time'
BREAK on thread#
SET pages 60 lines 131 
SET FEEDBACK OFF VERIFY OFF 
START title132 'Current Redo Log Status'
SPOOL rep_out\log_stat
SELECT   thread#, group#, sequence#, bytes, members, archived, status,
         first_change#, first_time
    FROM sys.v$log
ORDER BY thread#, group#;
SPOOL off
SET pages 22 lines 80 feedback on
CLEAR breaks 
CLEAR columns
TTITLE off
