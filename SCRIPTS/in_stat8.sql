REM FILE NAME:  in_stat8.sql
REM LOCATION:   Object Management\Indexes\Reports
REM FUNCTION:   Report on index statistics
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_indexes
REM
REM INPUTS:		1 = Index owner
REM				2 = Index name
REM
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


DEF iowner = '&OWNER'
DEF iname  = '&INDEX'
SET pages 56 lines 130 verify off feedback off
COLUMN owner                   format a8            heading "Owner"
COLUMN index_name              format a25           heading "Index"
COLUMN status                  format a7            heading "Status"
COLUMN blevel                  format 9999          heading " Tree| Level"
COLUMN leaf_blocks             format 9999          heading " Leaf| Blk"
COLUMN distinct_keys           format 9999999       heading " # Keys"
COLUMN avg_leaf_blocks_per_key format 9999          heading " Avg| Leaf Blocks| Key"
COLUMN avg_data_blocks_per_key format 9999          heading " Avg| Data Blocks| Key"
COLUMN clustering_factor       format 999999        heading " Cluster| Factor"
COLUMN num_rows                format 9999999       heading " Number| Rows"
COLUMN sample_size             format 9999999       heading " Sample| Size"
COLUMN last_analyzed                                heading " Analysis| Date"
REM
START title132 "Index Statistics Report"
SPOOL rep_out\in_stat8
REM
SELECT   owner, index_name, status, blevel, leaf_blocks, distinct_keys,
         avg_leaf_blocks_per_key, avg_data_blocks_per_key, clustering_factor,
         num_rows, sample_size, last_analyzed
    FROM dba_indexes
   WHERE owner LIKE UPPER ('&&iowner')
     AND index_name LIKE UPPER ('&&iname')
     AND num_rows > 0
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
