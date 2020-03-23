REM FILE NAME:  getcom.sql
REM LOCATION:   Object Management\Tables\Reports
REM FUNCTION:   Get all of a table's columns comments
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_col_comments 
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


ACCEPT owner prompt 'Enter owner name:'
SET heading off pages 0 verify off feedback off termout off
SPOOL rep_out\do_tabhp.sql 
SELECT UNIQUE    'execute table_help('
              || ''''
              || owner
              || ''''
              || ','
              || ''''
              || table_name
              || ''''
              || ');'
         FROM dba_col_comments
        WHERE owner = '&OWNER' AND LENGTH (comments) > 0;
SPOOL off
SET echo off lines 132
SET serveroutput on size 4000
SPOOL rep_out\getcom
START rep_out\do_tabhp.sql
SPOOL off
HOST del do_tabhp.sql
SET heading on pages 22 verify on feedback on termout on lines 80
