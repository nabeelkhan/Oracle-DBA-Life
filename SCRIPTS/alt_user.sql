REM FILE NAME:  alt_user.sql
REM LOCATION:  	Object Management\Tablespaces and DataFiles\Utilities
REM FUNCTION:   Alter multiple user's tablespace assignments
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_users - Be sure to change old and new default and temporary values.
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET HEADING OFF TERMOUT OFF ECHO OFF PAGES 0 VERIFY OFF
SET FEEDBACK OFF
SPOOL rep_out\ALT_USER.SQL
REM
SELECT    'ALTER USER '
       || username
       || -' DEFAULT TABLESPACE new_default
  TEMPORARY TABLESPACE new_temporary;'
  FROM dba_users
 WHERE default_tablespace = 'old_default'
   AND temporary_tablespace = 'old_temporary'
   AND username NOT IN ('SYSTEM', 'SYS', 'PUBLIC', '_NEXT_USER');
REM
SPOOL OFF
