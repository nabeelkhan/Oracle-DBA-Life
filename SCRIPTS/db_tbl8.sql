REM FILE NAME:  db_tbl8.sql
REM LOCATION:   Object Management\Tables\Reports
REM FUNCTION:   Generate table report
REM CATEGORY:   
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tables
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


CLEAR columns
COLUMN owner            format a15  heading 'Table | Owner'
COLUMN table_name                   heading Table
COLUMN tablespace_name  format A15  heading Tablespace
COLUMN pct_increase                 heading 'Pct|Increase'
COLUMN init                         heading 'Initial|Extent'
COLUMN next                         heading 'Next|Extent'
COLUMN partitioned      format a15  heading 'Partitioned?'
BREAK on owner on tablespace_name
SET pages 48 lines 132 echo off
START TITLE132 "ORACLE TABLE REPORT"
SPOOL rep_out\db_tbl8
SELECT   owner, tablespace_name, table_name, initial_extent init,
         next_extent NEXT, pct_increase, partitioned
    FROM sys.dba_tables
   WHERE owner NOT IN ('SYSTEM', 'SYS')
ORDER BY owner, tablespace_name, table_name;
SPOOL off
CLEAR columns
SET pages 22 lines 80
TTITLE off
CLEAR columns
CLEAR breaks
