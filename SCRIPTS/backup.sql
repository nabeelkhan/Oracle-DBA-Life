REM FILE NAME: 	backup.sql
REM LOCATION:   Backup Recovery\Reports
REM FUNCTION:   Show database datafile Archive status 
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.v_$datafile, sys.v_$backup 
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN name format a43
COLUMN arc heading 'Backup Status'
SET lines 132 pages 59 feedback off
START title132 "Database File Backup Status"
SPOOL rep_out\backup
SELECT NAME, a.status, DECODE (b.status, 'Active', 'Backup', 'Normal') arc,
       enabled, bytes, change#, TIME ARCHIVE
  FROM sys.v_$datafile a, sys.v_$backup b
 WHERE a.file# = b.file#;
SPOOL off
CLEAR columns
TTITLE off
