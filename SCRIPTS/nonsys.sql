REM FILE NAME:  nonsys.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Report on non-sys owned tables in SYSTEM tablespace
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tables
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner              format a15
COLUMN table_name         format a30
COLUMN tablespace_name    format a10
SET pages 48 lines 80 feedback off verify off
START title80 'Non-SYS Owned Tables in SYSTEM'
SPOOL rep_out/nonsys
SELECT owner, table_name, tablespace_name
  FROM dba_tables
 WHERE tablespace_name = 'SYSTEM' AND owner != 'SYS'
/
SPOOL OFF
SET pages 22 lines 80 feedback on verify on
CLEAR columns
TTITLE off
