REM FILE NAME:  datafile.sql
REM LOCATION:   Object Management\Tablespaces and DataFiles\Reports
REM FUNCTION:   Document file sizes and locations
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_data_files
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


CLEAR computes
COLUMN FILE_NAME                FORMAT A50
COLUMN TABLESPACE_NAME          FORMAT A15
COLUMN MEG                      FORMAT 99,999.90
START title80 'DATABASE DATAFILES'
SPOOL rep_out\datafile
BREAK ON TABLESPACE_NAME SKIP 1 ON REPORT
COMPUTE SUM OF MEG ON TABLESPACE_NAME
COMPUTE sum of meg on REPORT
SELECT   tablespace_name, file_name, bytes / 1048576 meg
    FROM dba_data_files
ORDER BY tablespace_name
/

SPOOL OFF
CLEAR columns
CLEAR computes
