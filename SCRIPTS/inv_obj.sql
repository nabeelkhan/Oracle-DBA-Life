REM FILE NAME:  inv_obj.sql
REM LOCATION:  	Object Management\Database Reports
REM FUNCTION:   Show all invalid objects in database
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_objects
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN object_name      FORMAT A30      HEADING 'Object|Name'
COLUMN owner            FORMAT a10      HEADING 'Object|Owner'
COLUMN last_time        FORMAT a20      HEADING 'Last Change|Date'
SET LINES 80 FEEDBACK OFF PAGES 0 VERIFY OFF
START title80 'Invalid Database Objects'
SPOOL rep_out/inv_obj
SELECT owner, object_name, object_type,
       TO_CHAR (last_ddl_time, 'DD-MON-YY hh:mi:ss') last_time
  FROM dba_objects
 WHERE status = 'INVALID'
/
SET LINES 80 FEEDBACK ON PAGES 22 VERIFY ON
CLEAR COLUMNS
TTITLE OFF
