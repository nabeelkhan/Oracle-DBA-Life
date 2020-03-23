REM FILE NAME:  dir_rep.sql
REM LOCATION:   Object Management\Database Reports
REM FUNCTION    Report on Directories known by the database
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_directories
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner            FORMAT a10   HEADING 'Owner'
COLUMN directory_name   FORMAT a10   HEADING 'Directory'
COLUMN directory_path   FORMAT a40   HEADING 'Full Path'
SET VERIFY OFF PAGES 58 LINES 78 FEEDBACK OFF
START title80 'Database Directories Report'
SPOOL rep_out\dir_rep
SELECT   owner, directory_name, directory_path
    FROM dba_directories
ORDER BY owner;
SPOOL OFF
