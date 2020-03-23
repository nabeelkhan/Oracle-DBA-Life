REM FILE NAME:  run_fprc.sql
REM LOCATION:  	Object Management\Functions,Procedures, and Packages\Utilities
REM FUNCTION:   Generate and execute the exe_fprc.sql procedure
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_source, dba_objects
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM Limitations : Must have access to dba_source and dba_objects.
REM               The FPRC_RCT.SQL procedure must be in same directory
REM
REM***********************************************************************************


COLUMN dbname new_value db noprint
PAUSE Use % for a wildcard - Press enter to continue
ACCEPT owner prompt 'Enter object owner: '
ACCEPT type  prompt 'Enter object type: '
ACCEPT name  prompt 'Enter object name: '
PROMPT Working....
SET echo off heading off verify off feedback off
SELECT VALUE dbname
  FROM v$parameter
 WHERE NAME = 'db_name';
SPOOL rep_out\do_fprc.sql
SELECT UNIQUE (   'start fprc_rct '
               || a.owner
               || ' '
               || '"'
               || a.TYPE
               || '"'
               || ' '
               || a.NAME
              )
         FROM dba_source a, dba_objects b
        WHERE a.owner LIKE UPPER ('&owner')
          AND a.TYPE LIKE UPPER ('&type')
          AND a.NAME LIKE UPPER ('&name')
          AND a.owner = b.owner
          AND a.TYPE = b.object_type
          AND a.NAME = b.object_name;
SPOOL off
SET termout off 
SPOOL rep_out\run_fprc.sql
START rep_out\do_fprc.sql
SPOOL off
UNDEF owner
UNDEF type
UNDEF name
CLEAR columns
SET echo off heading on verify on feedback on
