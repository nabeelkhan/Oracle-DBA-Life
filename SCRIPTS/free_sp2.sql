REM FILE NAME:  free_sp2.sql
REM LOCATION:   Object Management\Tablespaces and DataFiles\Reports
REM FUNCTION:   Provide data on tablespace extent status
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   free_space, dbms_revealnet package 
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
SET pages 58 LINES 130 echo off
COLUMN tablespace      heading Name                  format a30
COLUMN file_id         heading File#                 format 99999
COLUMN pieces          heading Frag                  format 9999
COLUMN free_bytes      heading 'Free Meg'            format 99,999.99
COLUMN largest_bytes   heading 'Biggest|Free Meg'    format 99,999.99
COLUMN ratio           heading 'Percent of|Free Meg' format 999.999
COLUMN total_meg       heading 'Total|Meg'           format 99,999.999
COLUMN used_meg        heading 'Total|Used Meg'      format 99,999,999.99
COLUMN meg_ratio       heading 'Percent Free|Total Meg'     format 999.99
START title132 "FREE SPACE REPORT"
SPOOL rep_out\free_sp2
SELECT   a.TABLESPACE, COUNT (a.TABLESPACE) files, SUM (a.pieces) pieces,
         SUM (a.free_bytes) / 1048576 free_bytes,
         SUM (a.largest_bytes) / 1048576 largest_bytes,
         SUM (a.largest_bytes) / SUM (a.free_bytes) * 100 ratio,
         dbms_revealnet.get_bytes (a.TABLESPACE) / 1048576
               total_meg,
           (dbms_revealnet.get_bytes (a.TABLESPACE) / 1048576)
         - (SUM (a.free_bytes) / 1048576)
               used_meg,
         (SUM (a.free_bytes) / dbms_revealnet.get_bytes (a.TABLESPACE) * 100)
               meg_ratio
    FROM free_space a
GROUP BY TABLESPACE;
SPOOL off
CLEAR columns
SET FEED ON
SET FLUSH ON
SET VERIFY ON
SET pages 22 LINES 80
CLEAR columns
TTITLE off
