REM FILE NAME:  com_proc.sql
REM LOCATION:   Application Tuning\Utilities
REM FUNCTION:   Create a compile list for invalid procedures
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_objects
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


DEFINE cr='chr(10)'
SET HEADING OFF PAGES 0 ECHO OFF TERMOUT OFF FEEDBACK OFF VERIFY OFF
SPOOL rep_out\com_proc
SELECT    'alter '
       || DECODE (object_type, 'PACKAGE BODY', 'PACKAGE', object_type)
       || ' '
       || owner
       || '.'
       || object_name
       || ' compile;'
  FROM dba_objects
 WHERE status = 'INVALID'
/

SPOOL OFF
SET HEADING ON TERMOUT ON FEEDBACK ON VERIFY ON
UNDEF cr
