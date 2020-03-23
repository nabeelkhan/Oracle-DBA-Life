REM FILE NAME:  db_role.sql
REM LOCATION:   Security Administration\Reports
REM FUNCTION:   GENERATE ROLES REPORT
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_sys_privs
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET flush off term off pagesize 58  linesize 78 echo off
COLUMN grantee          heading 'User or Role'
COLUMN admin_option     heading 'Admin?'
BREAK on grantee
START title80 'System Privilege Report'
SPOOL rep_out\db_role
SELECT   grantee, PRIVILEGE, admin_option
    FROM sys.dba_sys_privs
ORDER BY grantee;
SPOOL off
SET flush on term on pagesize 22  linesize 80
CLEAR columns
CLEAR breaks
TTITLE off
