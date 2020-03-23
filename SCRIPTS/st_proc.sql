REM FILE NAME:  st_proc.sql
REM LOCATION:   Object Management\Functions,Procedures, and Packages\Reports
REM FUNCTION:   Generate a list of stored code
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_objects
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN OBJECT_TYPE FORMAT A12 HEADING 'Module|Type' 
COLUMN OBJECT_NAME FORMAT A40 HEADING 'Module|Name'
COLUMN owner       format a10 heading 'Module|Owner'
SET LINES 80 verify off feedback off
SET PAGES 58
BREAK on owner on object_type
@TITLE80 'STORED PROCEDURES'
SPOOL rep_out\st_proc
SELECT   owner, object_type, object_name
    FROM dba_objects
   WHERE object_type IN ('FUNCTION', 'PACKAGE', 'PACKAGE BODY', 'PROCEDURE')
ORDER BY owner, object_type
/
SPOOL off
CLEAR columns
CLEAR breaks
SET lines 80 pages 22 verify on feedback on
TTITLE OFF
