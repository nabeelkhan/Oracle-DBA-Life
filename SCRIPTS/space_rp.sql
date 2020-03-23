REM FILE NAME:  space_rp.sql
REM LOCATION:   Object Management\Tables\Reports
REM FUNCTION:   Execute SPACE procedure
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   space.sql script to be run first
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM

SET heading off feedback off verify off echo off
SET serveroutput on size 10000
COLUMN dbname new_value db noprint
SELECT NAME dbname
  FROM v$database;
SPOOL rep_out/space_rp
EXECUTE space;
SPOOL off
SET heading on feedback on verify on
CLEAR columns
