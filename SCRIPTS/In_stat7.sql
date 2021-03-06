REM FILE NAME:  in_stat7.sql
REM LOCATION:   Object Management\Indexes\Reports
REM FUNCTION:   Report on index statistics
REM TESTED ON:  7.3.3.5
REM PLATFORM:   non-specific
REM REQUIRES:   dba_indexes
REM
REM INPUTS:		1 = Index owner
REM				2 = Index name
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


DEF iowner = '&OWNER'
DEF iname  = '&INDEX'
SET pages 56 lines 130 verify off feedback off
COLUMN owner                   format a20           heading "Owner"
COLUMN index_name              format a20           heading "Index"
COLUMN status                  format a11           heading "Status"
COLUMN blevel                  format 9,999,999,999 heading "Tree Level"
COLUMN leaf_blocks             format 999,999,999   heading "Leaf Blk"
COLUMN distinct_keys           format 999,999       heading "# Keys"
COLUMN avg_leaf_blocks_per_key format 999,999,999   heading "Avg. LB/Key"
COLUMN avg_data_blocks_per_key format 999,999,999   heading "Avg. DB/Key"
COLUMN clustering_factor       format 999,999,999   heading "Clstr Factor"
REM
START title132 "Index Statistics Report"
SPOOL rep_out\in_stat7
REM
SELECT   owner, index_name, status, blevel, leaf_blocks, distinct_keys,
         avg_leaf_blocks_per_key, avg_data_blocks_per_key, clustering_factor
    FROM dba_indexes
   WHERE owner LIKE UPPER ('&&iowner') AND index_name LIKE UPPER ('&&iname')
ORDER BY 1, 2;
REM
SPOOL off
SET pages 22 lines 80 verify on feedback on
CLEAR columns
UNDEF iowner
UNDEF iname
UNDEF owner
UNDEF name
TTITLE off
