REM FILE NAME:  lib_rep.sql
REM LOCATION:   Object Management\Database Reports
REM FUNCTION:   Document External Library Entries in Database
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_libraries
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner            FORMAT a10      HEADING 'Library|Owner'
COLUMN library_name     FORMAT a30      HEADING 'Library|Name'
COLUMN file_spec        FORMAT a40      HEADING 'File|Specification'
COLUMN dynamic          FORMAT a10      HEADING 'Dynamic'
COLUMN stauts           FORMAT a10      HEADING 'Status'
BREAK ON owner
SET FEEDBACK OFF VERIFY OFF LINES 78 PAGES 58
START title132 'Database External Libraries Report'
SPOOL rep_out\lib_rep
SELECT   owner, library_name, file_spec, dynamic, status
    FROM dba_libraries
ORDER BY owner;
SPOOL OFF
