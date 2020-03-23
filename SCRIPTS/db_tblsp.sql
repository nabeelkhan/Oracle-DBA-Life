REM FILE NAME:  db_tblsp.sql
REM LOCATION:   Object Management\Tablespaces and DataFiles\Reports
REM FUNCTION:   Generate a report of Tablespace Defaults
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tablespaces
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN tablespace_name  format a15           heading 'Tablespace|Name'
COLUMN initial_extent   format 9,999,999     heading 'Initial|Extent|(Bytes)'
COLUMN next_extent      format 9,999,999     heading 'Next|Extent|(Bytes)'
COLUMN min_extents      format 999           heading 'Minimum|Extents'
COLUMN max_extents      format 999           heading 'Maximum|Extents'
COLUMN pct_increase     format 999           heading 'Percent|Increase'
COLUMN status           format a15           heading 'Status'
SET pages 60 lines 80 feedback off verify off echo off
START title80 "Tablespace Defaults Report"
SPOOL rep_out\db_tblsp
SELECT   tablespace_name, initial_extent, next_extent, min_extents,
         max_extents, pct_increase, status
    FROM dba_tablespaces
ORDER BY tablespace_name;
SPOOL off
SET feedback on verify on
