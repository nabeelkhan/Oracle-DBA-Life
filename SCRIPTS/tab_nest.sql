REM FILE NAME:  tab_nest.sql
REM LOCATION:   Object Management\Tables\Reports
REM FUNCTION:   Report on Nested Tables
REM TESTED ON:  8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   sys.dba_nested_tables
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner                    FORMAT a10 HEADING 'Owner'
COLUMN table_name               FORMAT a20 HEADING 'Store Table'
COLUMN table_type_owner         FORMAT a10 HEADING 'Type|Owner'
COLUMN table_type_name          FORMAT a15 HEADING 'Type|Name'
COLUMN parent_table_name        FORMAT a25 HEADING 'Parent|Table'
COLUMN parent_table_column      FORMAT a15 HEADING 'Parent|Column'
SET PAGES 58 LINES 132 VERIFY OFF FEEDBACK OFF
START title132 'Nested Tables'
BREAK ON owner
SPOOL rep_out\tab_nest
SELECT   owner, table_name, table_type_owner, table_type_name,
         parent_table_name, parent_table_column,
         LTRIM (storage_spec) storage_spec, LTRIM (return_type) return_type
    FROM sys.dba_nested_tables
ORDER BY owner;
SPOOL OFF
