REM FILE NAME:  clus_siz.sql
REM LOCATION:   Object Management\Cluster Reports
REM FUNCTION:   Generate a cluster sizing report
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_clusters
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner                    format a10
COLUMN cluster_name             format a15              heading "Cluster"
COLUMN tablespace_name          format a15              heading "Tablespace"
COLUMN pct_free                 format 999999           heading "% Free"
COLUMN pct_used                 format 999999           heading "% Used"
COLUMN key_size                 format 999999           heading "Key Size"
COLUMN ini_trans                format 999              heading "IT"
COLUMN max_trans                format 999999           heading "Max Tran"
COLUMN initial_extent           format 999999999        heading "Initial Ext"
COLUMN next_extent              format 999999999        heading "Next Ext"
COLUMN max_extents              format 9999             heading "Max Ext"
COLUMN pct_increase             format 9999             heading "% Inc"
SET pages 56 lines 130 feedback off
START title132 "Cluster Sizing Report"
BREAK on owner on tablespace_name
SPOOL rep_out\clus_siz
SELECT   owner, tablespace_name, cluster_name, pct_free, pct_used, key_size,
         ini_trans, max_trans, initial_extent, next_extent, min_extents,
         max_extents, pct_increase
    FROM dba_clusters
ORDER BY 1, 2, 3
/


SPOOL off
CLEAR columns
CLEAR breaks
SET pages 22 lines 80 feedback on
PAUSE Press enter to continue
