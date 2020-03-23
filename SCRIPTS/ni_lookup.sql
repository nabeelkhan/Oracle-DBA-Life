REM FILE NAME: 	ni_lookup.sql  
REM LOCATION:   Database Tuning\File I/O Reports
REM FUNCTION:  	Non-index lookup ratios 
REM  FUNCTION:
REM TESTED ON:  8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN value format 999.9999
COLUMN name format a30
COLUMN meas_date format a16
REM column delta format 999.9999
SET pages 0 lines 80
SET echo off
START title80 'Non-Index Lookups Ratio'
SPOOL rep_out/ni_lookup
SELECT   NAME, VALUE, delta, TO_CHAR (meas_date, 'dd-mon-yy hh24:mi') meas_date
    FROM dba_running_stats
   WHERE NAME = 'Non-Index Lookups Ratio'
     AND TRUNC (meas_date) > TO_DATE ('&dd_mon_yy', 'dd-mon-yy')
ORDER BY meas_date
/
SPOOL off
TTITLE off
