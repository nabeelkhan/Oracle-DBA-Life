REM FILE NAME:  db_trig.sql
REM LOCATION:   Object Management\Trigger Reports
REM FUNCTION:   Report on all triggers by username
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_triggers
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner            format a10
COLUMN trigger_name     format a20      heading "Trigger"
COLUMN trigger_type     format a20      heading "Type"
COLUMN triggering_event format a10      heading "Event"
COLUMN table            format a40      heading "Trigger Table"
REM
BREAK on owner
SET verify off  feedback off lines 130 pages 58 echo off
START title132 "Trigger Status Report"
SPOOL  rep_out\db_trig
REM
SELECT   owner, trigger_name, trigger_type, triggering_event,
            table_owner
         || '.'
         || table_name "Table", status
    FROM dba_triggers
   WHERE owner = UPPER ('&trigger_owner')
ORDER BY 1, 5, 2;
SPOOL off
CLEAR columns 
CLEAR breaks
SET verify on  feedback on lines 80 pages 22
TTITLE off
