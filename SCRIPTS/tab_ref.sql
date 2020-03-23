REM FILE NAME:  tab_ref.sql
REM LOCATION:   Object Management\Collection Reports
REM FUNCTION:   Generate a list of all REF columns in the database
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_refs
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner              FORMAT a8  HEADING 'Owner'
COLUMN table_name         FORMAT a23 HEADING 'Table|Name'
COLUMN column_name        FORMAT a15 HEADING 'Column|Name'
COLUMN with_rowid         FORMAT a5  HEADING 'With|Rowid'
COLUMN is_scoped          FORMAT a6  HEADING 'Scoped'
COLUMN scope_table_owner  FORMAT a8  HEADING 'Scope|Table|Owner'
COLUMN scope_table_name   FORMAT a15 HEADING 'Scope|Table|Name' 
BREAK ON owner
SET PAGES 58 LINES 130 FEEDBACK OFF VERIFY OFF
START title132 'Database REF Report'
SPOOL rep_out\tab_ref
SELECT   owner, table_name, column_name, with_rowid, is_scoped,
         scope_table_owner, scope_table_name
    FROM dba_refs
ORDER BY owner;
SPOOL OFF
TTITLE OFF
