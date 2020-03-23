REM FILE NAME:  types.sql
REM LOCATION:   Object Management\Collection Reports
REM FUNCTION:   Provide basic report of all database types
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_types
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner         FORMAT a10     HEADING 'Type|Owner'
COLUMN type_name     FORMAT a30     HEADING 'Type|Name'
COLUMN typecode      FORMAT a27     HEADING 'Type|Code'
COLUMN predefined    FORMAT a11     HEADING 'Predefined?'
COLUMN incomplete    FORMAT a11     HEADING 'Incomplete?'
COLUMN methods       FORMAT 9999999 HEADING '#|Methods'
COLUMN attributes    FORMAT 999999  HEADING '#|Attrib'
SET LINES 130 PAGES 58 VERIFY OFF FEEDBACK OFF
BREAK ON owner
START title132 'Database Types Report'
SPOOL rep_out\types
SELECT   DECODE (owner, NULL, 'SYS-GEN', owner) owner, type_name, typecode,
         ATTRIBUTES, methods, predefined, incomplete
    FROM dba_types
ORDER BY owner, type_name;
SPOOL OFF
TTITLE OFF
