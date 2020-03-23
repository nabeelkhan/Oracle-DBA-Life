REM FILE NAME:  sqlmem.sql
REM LOCATION:   Application Tuning\Reports
REM FUNCTION:   Generate a report of SQL Area Memory Usage
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.v_$sqlarea, dba_users
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN sql_text      FORMAT a40   HEADING Text word_wrapped
COLUMN sharable_mem               HEADING Shared|Bytes
COLUMN persistent_mem             HEADING Persistent|Bytes
COLUMN parse_calls                HEADING Parses
COLUMN users         FORMAT a15   HEADING "User"
COLUMN executions                 HEADING "Executions"
START title132 "Users SQL Area Memory Use"
SPOOL rep_out\sqlmem
SET LONG 1000 PAGES 59 LINES 132 ECHO OFF
BREAK ON users
COMPUTE SUM OF sharable_mem ON users
COMPUTE SUM OF persistent_mem ON users
COMPUTE SUM OF runtime_mem ON users
SELECT   username users, sql_text, executions, parse_calls, sharable_mem,
         persistent_mem
    FROM sys.v_$sqlarea a, dba_users b
   WHERE a.parsing_user_id = b.user_id
     AND b.username LIKE UPPER ('%&user_name%')
ORDER BY 1;
SPOOL OFF
CLEAR COLUMNS
CLEAR COMPUTES
CLEAR BREAKS
SET PAGES 22 LINES 80
