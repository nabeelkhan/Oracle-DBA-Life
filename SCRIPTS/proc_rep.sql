REM FILE NAME:  proc_rep.sql
REM LOCATION:   Object Management\Functions,Procedures, and Packages\Reports
REM FUNCTION:   Report on Stored Code
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_objects, proc_count
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM

SET pages 53 lines 80 verify off feedback off echo off
COLUMN owner    format a10
COLUMN name     format a30
COLUMN type     format a9    word_wrapped
COLUMN status   format a7
COLUMN lines    format 9,999
BREAK on owner skip page on type
START title80 "Report on Stored Code"
SPOOL rep_out\proc_rep
SELECT   b.owner owner, b.object_type TYPE, b.object_name NAME,
         b.status status, b.last_ddl_time modified, lines
    FROM dba_objects b, proc_count a
   WHERE b.owner NOT IN ('SYS', 'SYSTEM')
     AND b.owner = a.owner
     AND b.object_type = a.TYPE
     AND b.object_name = a.NAME
ORDER BY 1, 2, 3
/
SPOOL off
SET pages 22 lines 80 verify on feedback on 
CLEAR breaks
CLEAR columns
TTITLE off
