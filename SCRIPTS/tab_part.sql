REM FILE NAME:  tab_part.sql
REM LOCATION:   Object Management\Tables\Reports
REM FUNCTION:   Report on partitioned table structure
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tab_partitions
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN table_owner      FORMAT a10 HEADING 'Owner'
COLUMN table_name       FORMAT a15 HEADING 'Table'
COLUMN partition_name   FORMAT a15 HEADING 'Partition'
COLUMN tablespace_name  FORMAT a15 HEADING 'Tablespace'
COLUMN high_value       FORMAT a10 HEADING 'Partition|Value'
SET LINES 78
START title80 'Table Partition Files'
BREAK ON table_owner ON table_name
SPOOL rep_out/tab_part
SELECT   table_owner, table_name, partition_name, high_value, tablespace_name,
         LOGGING
    FROM sys.dba_tab_partitions
ORDER BY table_owner, table_name
/
SPOOL OFF
TTITLE OFF
