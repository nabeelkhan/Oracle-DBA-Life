REM FILE NAME:  sqldrd.sql
REM LOCATION:   Application Tuning\Reports
REM FUNCTION:   Return the sql statements from the shared area with
REM             highest disk reads
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$sqlarea
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


ACCEPT access_level PROMPT "Enter a value for high disk reads: "
COLUMN parsing_user_id  FORMAT 9999999     HEADING 'User Id'
COLUMN executions       FORMAT 9999        HEADING 'Exec'
COLUMN sorts            FORMAT 99999       HEADING 'Sorts'
COLUMN command_type     FORMAT 99999       HEADING 'CmdT'
COLUMN disk_reads       FORMAT 999,999,999 HEADING 'Block Reads'
COLUMN sql_text         FORMAT a40         HEADING 'Statement' WORD_WRAPPED
SET LINES 130 VERIFY OFF FEEDBACK OFF echo off
START title132 'SQL Statements With High Reads'
SPOOL rep_out/sqldrd
SELECT   parsing_user_id, executions, sorts, command_type, disk_reads, sql_text
    FROM v$sqlarea
   WHERE disk_reads > &&access_level
ORDER BY disk_reads;
SPOOL OFF
SET LINES 80 VERIFY ON FEEDBACK ON
