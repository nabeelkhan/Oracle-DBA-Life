REM FILE NAME:  typ_meth.sql
REM LOCATION:   Object Management\Collection Reports
REM FUNCTION:   Create a report of type methods
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_type_methods
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner         FORMAT a10      HEADING 'Owner'
COLUMN type_name     FORMAT a20      HEADING 'Type|Name'
COLUMN method_name   FORMAT a20      HEADING 'Method|Name'
COLUMN method_type                   HEADING 'Method|Type'
COLUMN parameters    FORMAT 99999    HEADING '#|Param'
COLUMN results       FORMAT 99999    HEADING '#|Results'
COLUMN method_no     FORMAT 999999   HEADING 'Meth.|Number'
BREAK ON owner ON type_name
SET LINES 80 PAGES 58 VERIFY OFF FEEDBACK OFF
START title132 'Type Methods Report'
SPOOL rep_out\typ_meth
SELECT   owner, type_name, method_name, method_no, method_type, PARAMETERS,
         results
    FROM dba_type_methods
ORDER BY owner, type_name;
SPOOL OFF
TTITLE OFF
