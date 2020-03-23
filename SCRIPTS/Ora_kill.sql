REM FILE NAME:  Ora_kill.sql 
REM LOCATION:	Security Administration\Utilities
REM FUNCTION:   Kills a non-essential Oracle session
REM  FUNCTION:
REM TESTED ON:  8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM DEPENDANCIES: kill_ses.sql 
REM
REM***********************************************************************************


SET heading off termout off verify off echo off
SPOOL rep_out\kill_all.sql
SELECT    'execute kill_session('
       || CHR (39)
       || sid
       || CHR (39)
       || ','
       || CHR (39)
       || serial#
       || CHR (39)
       || ');'
  FROM v$session
 WHERE username IS NOT NULL
    OR username <> 'SYS'
/
SPOOL off
START rep_out\kill_all.sql
