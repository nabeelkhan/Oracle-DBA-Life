REM FILE NAME:  rm_us.sql
REM LOCATION:   Security Administration\Utilities
REM FUNCTION:   To build a script to remove all the objects owned by a 
REM             specified user.
REM TESTED ON:  8.1.5, 8.1.7, 9.0.1
REM
REM INPUTS:		1 = User name
REM				2 = File name of the resulting script
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM
REM******************** Knowledge Xpert for Oracle Administration ********************


SET verify off  feedback off  heading off echo off  pagesize 0

ACCEPT uname PROMPT 'Enter User Name to have objects rmoved: '
ACCEPT fname PROMPT 'Enter Name of file to be created with DROP commands: '
SPOOL rep_out\&fname

SELECT      'alter table '
         || owner
         || '.'
         || table_name
         || ' drop constraint '
         || constraint_name
         || ' cascade;'
    FROM dba_constraints
   WHERE (constraint_type = 'R') AND (owner = UPPER ('&uname'))
ORDER BY table_name, constraint_name;

SELECT DISTINCT    'DROP '
                || object_type
                || ' '
                || owner
                || '.'
                || object_name
                || ';'
           FROM dba_objects
          WHERE (object_type NOT IN ('INDEX')) AND (owner = UPPER ('&uname'));
SPOOL off
SET newpage 1
SELECT 'To drop &uname''s objects:'
  FROM DUAL;
SELECT '  1. Examine the file \rep_out\&fname'
  FROM DUAL;
SELECT '  2. SQL> start &fname'
  FROM DUAL;
SELECT '  3. Remove the file &fname'
  FROM DUAL;
