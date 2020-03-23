REM FILE NAME:  file_sta.sql
REM LOCATION:   Object Management\Tablespaces and DataFiles\Reports
REM FUNCTION:   Generate a file storage statisitics report
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.v_$parameter, sys.dba_data_files
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN file_name        format a23        heading 'File|Name'
COLUMN file_id          format 9999999    heading 'File|Number'
COLUMN tablespace_name  format a10        heading 'Tablespace'
COLUMN bytes            format 9999.99    heading 'Megs'
COLUMN status                             heading 'File|Status'
COLUMN value new_value block_size noprint
REM
SELECT VALUE
  FROM sys.v_$parameter
 WHERE NAME = 'db_block_size';
COLUMN blocks format 99,999               heading '&block_size byte|Blocks'
SET feedback off echo off lines 79 pages 57
START title80 'File Storage Statistics Report'
SPOOL rep_out\file_sta
REM
SELECT   file_name, file_id, status, tablespace_name,
         bytes / (1024 * 1024) bytes, blocks
    FROM sys.dba_data_files
ORDER BY file_id
/
SPOOL off
CLEAR columns
TTITLE off
