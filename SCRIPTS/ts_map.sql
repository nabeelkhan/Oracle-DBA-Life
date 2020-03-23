REM FILE NAME:  ts_map.sql
REM LOCATION:   Object Management\Tablespaces and DataFiles\Reports
REM FUNCTION:   create an extent map for a specific tablespace
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_free_space, dba_extents
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET pages 47 lines 132 verify off feedback off
COLUMN file_id heading 'File|id'
ACCEPT ts prompt 'Enter tablespace name to map: '
START title132 '&ts Mapping Report'
SPOOL rep_out/ts_map
SELECT   'free space' owner, '      ' OBJECT, file_id, block_id, blocks
    FROM dba_free_space
   WHERE tablespace_name = UPPER ('&ts')
UNION
SELECT   SUBSTR (owner, 1, 20), SUBSTR (segment_name, 1, 32), file_id,
         block_id, blocks
    FROM dba_extents
   WHERE tablespace_name = UPPER ('&ts')
ORDER BY 3, 4;
SPOOL off
UNDEF ts
SET pages 22 lines 80 verify on feedback on
CLEAR columns
TTITLE off
