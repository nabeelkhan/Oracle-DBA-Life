REM FILE NAME:  clu_typ.sql
REM LOCATION:   Object Management\Cluster Reports
REM FUNCTION:   Report on new DBA_CLUSTER columns
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_clusters
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner                    format a10      heading "Owner"
COLUMN cluster_name             format a15      heading "Cluster"
COLUMN tablespace_name          format a10      heading "Tablespace"
COLUMN avg_blocks_per_key       format 999999   heading "Blocks per Key"
COLUMN cluster_type             format a8       heading "Type"
COLUMN function                 format 999999   heading "Function"
COLUMN hashkeys                 format 99999    heading "# of Keys" 
SET pages 56 lines 132 feedback off
START title132 "Cluster Type Report"
SPOOL rep_out\clu_type
SELECT   owner, cluster_name, tablespace_name, avg_blocks_per_key,
         cluster_type, FUNCTION, HASHKEYS
    FROM dba_clusters
ORDER BY 2
/


SPOOL off
SET pages 22 lines 80 feedback on
CLEAR columns
TTITLE off
