REM FILE NAME:  db_obj.sql
REM LOCATION:   Object Management\Database Reports
REM FUNCTION:   Report on all objects and their status
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_objects
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN  owner           format a17      heading "Owner"
COLUMN  object_name     format a23      heading "Object"
COLUMN object_type      format a20      heading "Type of Object"
COLUMN status           format a10      heading "Status"
REM
SET verify off  feedback off lines 80 pages 58 heading off
REM 
BREAK on owner on  object_type
START  title80 "Database Object Status"
SPOOL rep_out\db_obj
REM
PROMPT Enter object type or % for all objects
REM
SELECT   owner, object_type, object_name, status
    FROM dba_objects
   WHERE object_type LIKE UPPER ('&type')
ORDER BY 1, 2;
SPOOL off
SET verify on  feedback on lines 80 pages 22 heading on
CLEAR columns
CLEAR breaks
UNDEF type
