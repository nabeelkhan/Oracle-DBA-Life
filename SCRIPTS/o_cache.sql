REM FILE NAME:  o_cache.sql
REM LOCATION:   Application Tuning\Reports
REM FUNCTION:   Report Stored Object Statistics
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$db_object_cache
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner         format a11      heading Schema
COLUMN name          format a30      heading Object|Name
COLUMN namespace                     heading Name|Space
COLUMN type                          heading Object|Type
COLUMN kept          format a4       heading Kept
COLUMN sharable_mem  format 999,999  heading Shared|Memory
COLUMN executions    format 999,999  heading Executes
SET lines 132 pages 47 feedback off
@title132 'Oracle Objects Report'
BREAK on owner on namespace on type
SPOOL rep_out/o_cache
SELECT   owner, namespace, TYPE, NAME, sharable_mem, loads, executions, locks,
         pins, kept
    FROM v$db_object_cache
   WHERE TYPE NOT IN ('NOT LOADED', 'NON-EXISTENT') AND executions > 0
ORDER BY owner, namespace, TYPE, executions DESC;
SPOOL off
SET lines 80 pages 22 feedback on
CLEAR columns
CLEAR breaks
TTITLE off
