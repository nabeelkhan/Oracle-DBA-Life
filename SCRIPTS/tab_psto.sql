REM FILE NAME:  tab_psto.sql
REM LOCATION:   Object Management\Tables\Reports
REM FUNCTION:   Provide data on partitioned table storage characteristics
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tab_partitions
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN table_owner              FORMAT a6       HEADING 'Owner'
COLUMN table_name               FORMAT a14      HEADING 'Table'
COLUMN partition_name           FORMAT a9       HEADING 'Partition'
COLUMN tablespace_name          FORMAT a11      HEADING 'Tablespace'
COLUMN pct_free                 FORMAT 9999     HEADING '%|Free'
COLUMN pct_used                 FORMAT 9999     HEADING '%|Used'
COLUMN ini_trans                FORMAT 9999     HEADING 'Init|Tran'
COLUMN max_trans                FORMAT 9999     HEADING 'Max|Tran'
COLUMN initial_extent           FORMAT 9999999  HEADING 'Init|Extent'
COLUMN next_extent              FORMAT 9999999  HEADING 'Next|Extent'
COLUMN max_extent                               HEADING 'Max|Extents'
COLUMN pct_increase             FORMAT 999      HEADING '%|Inc'
COLUMN partition_position       FORMAT 9999     HEADING 'Part|Nmbr'
SET LINES 130
START title132 'Table Partition File Storage'
BREAK ON table_owner on table_name
SPOOL rep_out/tab_psto
SELECT   table_owner, table_name, tablespace_name, partition_name,
         partition_position, pct_free, pct_used, ini_trans, max_trans,
         initial_extent, next_extent, max_extent, pct_increase
    FROM sys.dba_tab_partitions
ORDER BY table_owner, table_name
/
SPOOL OFF
TTITLE OFF
