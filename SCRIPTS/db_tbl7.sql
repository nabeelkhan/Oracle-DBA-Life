REM FILE NAME:  db_tbl7.sql
REM LOCATION:   Object Management\Tables\Reports
REM FUNCTION:   Generate table report
REM CATEGORY:   
REM TESTED ON:  7.3.3.5
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tables
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


CLEAR columns
COLUMN table_name                   heading Table
COLUMN tablespace_name format A15   heading Tablespace
COLUMN pct_increase        heading 'Pct|Increase'
COLUMN initial             heading 'Initial|Extent'
COLUMN next                heading 'Next|Extent'
BREAK on owner on tablespace_name
SET pages 48 lines 132
START TITLE132 "ORACLE TABLE REPORT"
SPOOL rep_out\db_tbl7
SELECT   owner, tablespace_name, table_name, initial_extent inital,
         next_extent NEXT, pct_increase
    FROM sys.dba_tables
   WHERE owner NOT IN ('SYSTEM', 'SYS')
ORDER BY owner, tablespace_name, table_name;
SPOOL off
CLEAR columns
SET pages 22 lines 80
TTITLE off
CLEAR columns
CLEAR breaks
