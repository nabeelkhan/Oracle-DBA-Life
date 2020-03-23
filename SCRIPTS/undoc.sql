REM FILE NAME:  undoc73.sql
REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Script for getting undocumented init.ora ( 7.3 and above )
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   Must be logged in as SYS
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM

COLUMN parameter         format a37              heading "Parameter"
COLUMN description       format a30 word_wrapped heading "Description"
COLUMN "Session Value"   format a13              heading "Session Value"
COLUMN "Instance Value"  format a14              heading "Instance Value"
SET verify off feedback off termout off echo off pagesize 0 embedded on
SET heading off
SET termout off
START title132 'Undocumented Parameters Report'
SPOOL rep_out/undoc73
SELECT a.ksppinm "Parameter", a.ksppdesc "Description",
       b.ksppstvl "Session Value", c.ksppstvl "Instance Value"
  FROM x$ksppi a, x$ksppcv b, x$ksppsv c
 WHERE a.indx = b.indx AND a.indx = c.indx AND a.ksppinm LIKE '/_%' ESCAPE '/'
/
SPOOL off
TTITLE OFF
