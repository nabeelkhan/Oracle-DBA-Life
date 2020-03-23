REM FILE NAME:  db_view7.sql
REM LOCATION:   Object Management\View Reports
REM FUNCTION:   Report on database views by owner
REM CATEGORY:   
REM TESTED ON:  7.3.3.5
REM PLATFORM:   non-specific
REM REQUIRES:   dba_views, dba_objects
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM Limitations:   If your view definitions are greater than 2000 
REM                characters then increase the set long. This can be 
REM                determined by querying the DBA_VIEWS table's 
REM                text_length column for the max value: 
REM
REM                select max(text_length) from dba_views;
REM
REM***********************************************************************************


SET pages 59 lines 131 feedback off echo off
COLUMN text             format a75
COLUMN owner            format a20
COLUMN view_name        format a20
COLUMN status           format a7
SET long 2000
START title132 "Database Views Report"
SPOOL rep_out\db_view7
SELECT   v.owner, v.view_name, v.text, o.status
    FROM dba_views v, dba_objects o
   WHERE v.owner LIKE UPPER ('%&owner_name')
     AND o.owner = v.owner
     AND o.object_type = 'VIEW'
     AND o.object_name = v.view_name
ORDER BY o.status, v.view_name;
SPOOL off
SET pages 22 lines 80 feedback on echo on
CLEAR columns
TTITLE off
