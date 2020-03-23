REM FILE NAME:  db_tgrnt.sql
REM LOCATION:   Security Administration\Reports
REM FUNCTION:   Report on database table or procedure grants given to a user
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tab_privs, dba_objects
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN table_name format a16 heading 'Table or|Procedure'
COLUMN grantee    format a16 heading 'Role or|User'
COLUMN privilege  format a10 heading 'Granted|Privilege'
COLUMN object_type           heading 'Type of|Object'
ACCEPT user prompt 'Enter user name: '
SET lines 80 feedback off verify off echo off
@title80 'Table and Procedure Grants by User/Role'
BREAK on object_type on grantee on table_name
SPOOL rep_out\db_tgrnt
SELECT   grantee, table_name, PRIVILEGE, object_type
    FROM dba_tab_privs a, dba_objects b
   WHERE grantee LIKE UPPER ('%&user%')
     AND a.owner = b.owner
     AND a.table_name = b.object_name
ORDER BY 4, 1, 2
/
SPOOL off
SET feedback on verify on
CLEAR columns
CLEAR breaks
TTITLE off
