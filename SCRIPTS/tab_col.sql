REM FILE NAME:  tab_col.sql
REM LOCATION:   Object Management\Tables\Reports
REM FUNCTION:   Report on Table and View Column Definitions
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tab_columns, dba_objects
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner            format a10      heading Owner
COLUMN table_name       format a30      heading "Table or View Name"
COLUMN column_name      format a32      heading "Table or View Column"
COLUMN data_type        format a15      heading "Data|Type"
COLUMN data_length                      heading Length
COLUMN nullable         format a5       heading Null?
BREAK on owner on table_name skip 1
SET lines 132 pages 48 feedback off verify off
START title132 "Table Columns Report"
SPOOL rep_out/tab_col
SELECT   a.owner,    table_name
                  || ' '
                  || object_type table_name, column_name,
         data_type, data_length, DECODE (nullable, 'N', 'NO', 'YES') nullable
    FROM dba_tab_columns a, dba_objects b
   WHERE a.owner NOT IN ('SYS', 'SYSTEM')
     AND a.owner = UPPER ('&owner')
     AND a.owner = b.owner
     AND a.table_name LIKE UPPER ('%&table%')
     AND a.table_name = b.object_name
     AND object_type IN ('TABLE', 'VIEW', 'CLUSTER')
ORDER BY owner, object_type, table_name, column_id
/
SPOOL off
TTITLE off
SET lines 80 pages 22 feedback on verify on echo off
