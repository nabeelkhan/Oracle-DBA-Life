REM FILE NAME:  tab_pkey.sql
REM LOCATION:   Object Management\Tables\Reports
REM FUNCTION:   Report Table Partition Keys
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   SYS.DBA_PART_KEY_COLUMNS
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN OWNER           FORMAT A15 HEADING 'Partition|Owner'
COLUMN NAME            FORMAT A15 HEADING 'Partition|Name'
COLUMN COLUMN_NAME     FORMAT a20 HEADING 'Column|Name'
COLUMN COLUMN_POSITION FORMAT 999 HEADING 'Key|Pos'
SET lines 78
START title80 'Table Partition Keys'
SPOOL rep_out\tab_pkey
SELECT   owner, NAME, column_name, column_position
    FROM sys.dba_part_key_columns
ORDER BY owner, NAME;
SPOOL off
TTITLE OFF
