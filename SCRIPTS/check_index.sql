REM FILE NAME:  check_index.sql
REM LOCATION:   Object Management\Indexes\Reports
REM FUNCTION:   Report on indexes
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_indexes, dba_ind_columns
REM
REM  This is a part of the Nabeel Khan's Script Library
REM  Copyright (C) 2004 NabeelKhan.com 
REM  All rights reserved. 
REM 
REM******************** NK's Script for Oracle Administration ********************
COLUMN owner                    FORMAT a8       HEADING 'Index|Owner'
COLUMN index_name               FORMAT a27      HEADING 'Index'
COLUMN index_type               FORMAT a6       HEADING 'Type|Index'
COLUMN table_owner              FORMAT a8       HEADING 'Table|Owner'
COLUMN table_name               FORMAT a24      HEADING 'Table Name'
COLUMN table_type               FORMAT a10      HEADING 'Table|Type'
COLUMN uniqueness               FORMAT a1       HEADING 'U|n|i|q|u|e'
COLUMN tablespace_name          FORMAT a13      HEADING 'Tablespace'
COLUMN column_name              FORMAT a25      HEADING 'Col. Name'
SET PAGES 58 LINES 130 FEEDBACK ON VERIFY ON
BREAK ON owner
Accept Owner PROMPT 'Enter Owner Name :'
Accept TableName PROMPT 'Enter Table Name :'
SELECT   a.owner, a.table_owner, a.table_name, a.index_name, a.index_type,
         b.column_position, b.column_name, c.tablespace_name,
         a.tablespace_name, a.uniqueness
    FROM dba_indexes a, dba_ind_columns b, dba_tables c
   WHERE a.owner = UPPER ('&Owner')
     AND a.owner = b.index_owner
     AND a.owner = c.owner
     AND a.table_name LIKE UPPER ('&TableName')
     AND a.table_name = b.table_name
     AND a.table_name = c.table_name
     AND a.index_name = b.index_name
ORDER BY a.owner, a.table_owner, a.table_name, a.index_name,
         b.column_position;