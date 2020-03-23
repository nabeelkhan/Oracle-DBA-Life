REM FILE NAME:  db_user8.sql
REM LOCATION:   Security Administration\Reports
REM FUNCTION:   Generate user report for Oracle8
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_users, dba_role_privs
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET pagesize 58  linesize 131 echo off
REM
COLUMN username                 format a10 heading User
COLUMN account_status           format a10 heading Status
COLUMN default_tablespace       format a15 heading Default
COLUMN temporary_tablespace     format a15 heading "Temporary"
COLUMN granted_role             format a21 heading Roles
COLUMN default_role             format a10 heading Default?
COLUMN admin_option             format a7  heading Admin?
COLUMN profile                  format a15 heading 'Users Profile'
REM
START title132 'ORACLE USER REPORT'
DEFINE output = rep_out\db_user8
BREAK on username skip 1 on account_status on default_tablespace on temporary_tablespace on profile
SPOOL &output
REM 
SELECT   username, account_status, default_tablespace, temporary_tablespace,
         PROFILE, granted_role, admin_option, default_role
    FROM sys.dba_users a, sys.dba_role_privs b
   WHERE a.username = b.grantee
ORDER BY username,
         account_status,
         default_tablespace,
         temporary_tablespace,
         PROFILE,
         granted_role;
REM
SPOOL off
SET termout on flush on feedback on verify on
CLEAR columns
CLEAR breaks
