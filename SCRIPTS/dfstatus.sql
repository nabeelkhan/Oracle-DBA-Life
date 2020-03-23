REM FILE NAME:  dfstatus.sql
REM LOCATION:   Object Management\Tablespaces and DataFiles\Reports
REM FUNCTION:   Document file sizes, locations and status
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_data_files
REM
REM  This is a part of the Xprt Module for Oracle Administration library. 
REM  Copyright (C) 2001 ZANS Technologies
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


CLEAR computes
COLUMN FILE_NAME                FORMAT A50
COLUMN TABLESPACE_NAME          FORMAT A15
COLUMN MEG                      FORMAT 99,999.90
SELECT   a.tablespace_name, file_name, dh.status, a.bytes / 1048576 meg
FROM dba_data_files a, v$datafile_header dh
where a.file_ID=dh.file#
ORDER BY 2 desc;
