REM FILE NAME:  db_user7.sql
REM LOCATION:   Security Administration\Reports
REM FUNCTION:   Generate user report
REM TESTED ON:  7.3.3.5
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tables
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET pagesize 58  linesize 131
REM
COLUMN username                 format a10 heading User
COLUMN default_tablespace       format a20 heading "Default Tablespace"
COLUMN temporary_tablespace     format a20 heading "Temporary Tablespace"
COLUMN granted_role             format a20 heading Roles
COLUMN default_role             format a9  heading Default?
COLUMN admin_option             format a7  heading Admin?
COLUMN profile                  format a15 heading 'Users Profile'
REM
START title132 'ORACLE USER REPORT'
DEFINE output = rep_out\db_user7
BREAK on username skip 1 on default_tablespace on temporary_tablespace on profile
SPOOL &output
REM 
SELECT   username, default_tablespace, temporary_tablespace, PROFILE,
         granted_role, admin_option, default_role
    FROM sys.dba_users a, sys.dba_role_privs b
   WHERE a.username = b.grantee
ORDER BY username,
         default_tablespace,
         temporary_tablespace,
         PROFILE,
         granted_role;
REM
SPOOL off
SET termout on flush on feedback on verify on
CLEAR columns
CLEAR breaks
