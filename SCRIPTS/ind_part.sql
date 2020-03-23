REM FILE NAME:  ind_part.sql
REM LOCATION:  	Object Management\Indexes\Reports
REM FUNCTION:   Report on partitioned index structure
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.dba_ind_partitions
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN index_owner      FORMAT a10 HEADING 'Owner'
COLUMN index_name       FORMAT a15 HEADING 'Index'
COLUMN partition_name   FORMAT a15 HEADING 'Partition'
COLUMN tablespace_name  FORMAT a15 HEADING 'Tablespace'
COLUMN high_value       FORMAT a10 HEADING 'Partition|Value'
SET LINES 78
START title80 'Index Partition Files'
BREAK ON index_owner ON index_name
SPOOL rep_out/ind_part
SELECT   index_owner, index_name, partition_name, high_value, tablespace_name,
         LOGGING
    FROM sys.dba_ind_partitions
ORDER BY index_owner, index_name
/
SPOOL OFF
