REM FILE NAME:  free_spc.sql
REM LOCATION:   Object Management\Tablespaces and DataFiles\Reports
REM FUNCTION:   Provide data on tablespace extent status
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   free_space view
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM  Modifications (Date, Who, Description)
REM
REM***********************************************************************************


SET FEED OFF
SET FLUSH OFF
SET VERIFY OFF echo off
SET pages 58 LINES 130
COLUMN tablespace      heading 'Name'              format a30
COLUMN files           heading ' Files'            format 99,999
COLUMN pieces          heading ' Fragments'        format 99,999
COLUMN free_bytes      heading ' Free Byte'        format 999,999,999
COLUMN free_blocks     heading ' Free Blk'         format 999,999,999
COLUMN largest_bytes   heading ' Largest Bytes'    format 999,999,999
COLUMN largest_blks    heading ' Largest Blks'     format 999,999,999
COLUMN ratio           heading ' Percent'          format 999.999
START title80 "FREE SPACE REPORT"
SPOOL rep_out\free_spc
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
