REM FILE NAME:  sgastat.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Report on the various SGA components and their sizes
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.v_$sgastat,sys.v_$sga
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN sum_bytes new_value divide_by noprint
COLUMN percent format 999.99999
SET pages 60 lines 80 feedback off verify off
BREAK on report
COMPUTE sum of bytes on report
COMPUTE sum of percent on report
SELECT SUM (VALUE) sum_bytes
  FROM sys.v_$sga;
START title80 'SGA Component Sizes Report'
SPOOL rep_out\sgastat
SELECT   a.NAME, a.bytes,
         a.bytes / &divide_by * 100 PERCENT
    FROM sys.v_$sgastat a
ORDER BY bytes DESC
/
SPOOL off
CLEAR columns
CLEAR breaks
SET pages 22 lines 80 feedback on verify on
TTITLE off
