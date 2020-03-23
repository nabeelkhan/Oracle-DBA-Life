REM FILE NAME:  ind_func.sql
REM LOCATION:   Object Management\Indexes\Utilities
REM FUNCTION:   Get data on functional index charcacteristics
REM TESTED ON:  8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_ind_expressions
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner             FORMAT a6               HEADING 'Owner'
COLUMN index_name        FORMAT a14              HEADING 'Index'
COLUMN table_name        FORMAT a20              HEADING 'Table'
COLUMN column_expression FORMAT a80 WORD_WRAPPED HEADING 'Expression'
SET LINES 130
START title132 'Functional Index Report'
BREAK ON index_owner on index_name
SPOOL rep_out/ind_func
SELECT   index_owner, index_name, table_name, column_expression
    FROM dba_ind_expressions
   WHERE index_owner LIKE '%&&owner%' AND index_name LIKE '%&&index%'
ORDER BY index_owner, index_name, column_position;
SPOOL OFF
TTITLE OFF
