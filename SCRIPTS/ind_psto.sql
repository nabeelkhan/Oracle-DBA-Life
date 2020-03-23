REM FILE NAME:  ind_psto.sql
REM LOCATION:   Object Management\Indexes\Reports
REM FUNCTION:   Provide data on partitioned index storage characteristics
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.dba_ind_partitions
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner                    FORMAT a6       HEADING 'Owner'
COLUMN index_name               FORMAT a14      HEADING 'Index|Name'
COLUMN partition_name           FORMAT a9       HEADING 'Partition'
COLUMN tablespace_name          FORMAT a11      HEADING 'Tablespace'
COLUMN pct_free                 FORMAT 9999     HEADING '%|Free'
COLUMN ini_trans                FORMAT 9999     HEADING 'Init|Tran'
COLUMN max_trans                FORMAT 9999     HEADING 'Max|Tran'
COLUMN initial_extent           FORMAT 9999999  HEADING 'Init|Extent'
COLUMN next_extent              FORMAT 9999999  HEADING 'Next|Extent'
COLUMN max_extent               FORMAT 9999999  HEADING 'Max|Extents'
COLUMN pct_increase             FORMAT 999      HEADING '%| Increase'
COLUMN distinct_keys            FORMAT 9999999  HEADING ' Distinct|Keys'
COLUMN clustering_factor        FORMAT 999999   Heading 'Clus|Factor'
SET LINES 130
SPOOL rep_out/ind_psto
START title132 'Index Partition File Storage'
BREAK ON index_owner on index_name
SELECT   index_owner, index_name, tablespace_name, partition_name, pct_free,
         ini_trans, max_trans, initial_extent, next_extent, max_extent,
         pct_increase, distinct_keys, clustering_factor
    FROM sys.dba_ind_partitions
ORDER BY index_owner, index_name
/
SPOOL OFF
