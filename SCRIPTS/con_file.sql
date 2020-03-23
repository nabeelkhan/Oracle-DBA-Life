REM FILE NAME:  con_file.sql
REM LOCATION:   Backup Recovery\Generate Recreation Scripts
REM FUNCTION:   Document control file location and status
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$controlfile
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN name     FORMAT a60   HEADING 'Control|File|Location' WORD_WRAPPED
COLUMN status   FORMAT a7    HEADING 'Control|File|Status'
SET LINES 78 FEEDBACK OFF VERIFY OFF
START title80 'Control File Status'
SPOOL rep_out\con_file
SELECT NAME, status
  FROM v$controlfile;
SPOOL OFF
