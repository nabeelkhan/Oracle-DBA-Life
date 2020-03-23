REM FILE NAME:  db_clus.sql
REM LOCATION:   Object Management\Cluster Reports
REM FUNCTION:   Generate a report on database clusters showing cluster, tablespace, tables, and column data
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_clusters,dba_clu_columns 
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner          format a10
COLUMN cluster_name      format a15 heading "Cluster"
COLUMN tablespace_name   format a20 heading "Tablespace"
COLUMN table_name        format a20 heading "Table"
COLUMN tab_column_name   format a20 heading "Table Column"
COLUMN clu_column_name   format a20 heading "Cluster Column"
SET pages 56 lines 130 feedback off
START title132 "Cluster Report"
BREAK on owner on tablespace_name on cluster_name on table_name
SPOOL rep_out\db_clus
SELECT   a.owner, tablespace_name, a.cluster_name, table_name, tab_column_name,
         clu_column_name
    FROM dba_clusters a, dba_clu_columns b
   WHERE a.cluster_name = b.cluster_name
ORDER BY 1, 2, 3, 4
/

SPOOL off
TTITLE off
CLEAR columns
CLEAR breaks
