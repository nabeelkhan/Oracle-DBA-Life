REM FILE NAME:  object.sql
REM LOCATION:   Object Management\Database Reports
REM FUNCTION:   Report on object creation and modification dates
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_objects
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN created      format a19
COLUMN modified     format a19
COLUMN object_type  format a10
COLUMN object_name  format a15
BREAK on owner on object_type
SET verify off feedback off lines 80 pages 57
@title132 'Object Modification and Creation Dates'
SPOOL rep_out\object
SELECT   owner, object_name, TO_CHAR (created, 'dd-mon-yy hh:mi:ss') created,
         TO_CHAR (last_ddl_time, 'dd-mon-yy hh:mi:ss') modified, object_type
    FROM dba_objects
   WHERE owner LIKE UPPER ('%&owner%')
     AND object_name LIKE UPPER ('%&object_name%')
ORDER BY owner, object_type
/
SPOOL off
UNDEF owner
UNDEF object_name
CLEAR columns
CLEAR breaks
SET verify on feedback on pages 22
