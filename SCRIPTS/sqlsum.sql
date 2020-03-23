REM FILE NAME:  sqlsum.sql
REM LOCATION:   Application Tuning\Reports
REM FUNCTION:   Generate a summary of SQL Area Memory Usage
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sql_summary created with crea_tab.sql script
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM

COLUMN areas                                HEADING Used|Areas
COLUMN sharable         FORMAT 999,999,999  HEADING Shared|Bytes
COLUMN persistent       FORMAT 999,999,999  HEADING Persistent|Bytes
COLUMN runtime          FORMAT 999,999,999  HEADING Runtime|Bytes
COLUMN username         FORMAT A15          HEADING "User" 
START TITLE80 "USERS SQL AREA MEMORY USE"
SPOOL rep_out\sqlsum
SET PAGES 59 LINES 80 
BREAK ON REPORT 
COMPUTE SUM OF sharable ON REPORT
COMPUTE SUM OF persistent ON REPORT
COMPUTE SUM OF runtime ON REPORT
SELECT   username, SUM (sharable_mem) sharable, SUM (persistent_mem) persistent,
         SUM (runtime_mem) runtime, COUNT (*) areas
    FROM sql_summary
GROUP BY username
ORDER BY 2;
SPOOL OFF
CLEAR COLUMNS
CLEAR BREAKS
SET PAGES 22 LINES 80
TTITLE OFF
