REM FILE NAME:  db_fspc.sql
REM LOCATION:   Object Management\Tablespaces and DataFiles\Reports
REM FUNCTION:   Generate free space report
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   free_space (created by crea_tab.sql)
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM

SET FEED OFF
SET FLUSH OFF
SET VERIFY OFF
SET pages 58 LINES 130
COLUMN tablespace      heading Name              format a30
COLUMN file_id         heading File#             format 99999
COLUMN pieces          heading Frag              format 9999
COLUMN free_bytes      heading 'Free Byte'
COLUMN free_blocks     heading 'Free Blk'
COLUMN largest_bytes   heading 'Biggest Bytes'
COLUMN largest_blks    heading 'Biggest Blks'
COLUMN ratio           heading 'Percent'         format 999.999
START title132 "FREE SPACE REPORT"
SPOOL rep_out\db_fspc
SELECT   TABLESPACE, COUNT (*) files, SUM (pieces) pieces,
         SUM (free_bytes) free_bytes, SUM (free_blocks) free_blocks,
         SUM (largest_bytes) largest_bytes, SUM (largest_blks) largest_blks,
         SUM (largest_bytes) / SUM (free_bytes) * 100 ratio
    FROM free_space
GROUP BY TABLESPACE;
SPOOL off
CLEAR columns
SET FEED ON
SET FLUSH ON
SET VERIFY ON
SET pages 22 LINES 80
CLEAR columns
TTITLE off
