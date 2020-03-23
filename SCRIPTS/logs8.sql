REM FILE NAME:  logs8.sql
REM LOCATION:   Database Tuning\Redo Log Reports
REM FUNCTION:   Provide a report on redo log history
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.v_$loghist
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


BREAK on thread#
PROMPT enter report start date (dd-mon-yy):
ACCEPT st_date
START title80 'Redo Log Activity Report'
SET lines 80 pages 60 feedback off verify off
COLUMN first_time format a20
SPOOL rep_out\logs8
SELECT   thread#, sequence#, first_change#,
         TO_CHAR (first_time, 'dd-mon-yyyy hh24:mi:ss') first_time,
         switch_change#
    FROM sys.v_$loghist
   WHERE first_time >= TO_DATE ('&st_date', 'dd-mon-yy')
ORDER BY thread#, sequence#
/
SPOOL off
CLEAR breaks 
UNDEF st_date
SET pages 22 feedback on verify on
