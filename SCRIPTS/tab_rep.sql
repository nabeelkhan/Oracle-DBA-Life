REM FILE NAME:  tab_rep.sql
REM LOCATION:   Object Management\Tables\Reports
REM FUNCTION:   Document table extended parameters
REM TESTED ON:  8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tables
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN owner            format a10 heading 'Owner'
COLUMN table_name       format a15 heading 'Table'
COLUMN tablespace_name  format a12 heading 'Tablespace'
COLUMN table_type_owner format a10 heading 'Type|Owner'
COLUMN table_type       format a13 heading 'Type'
COLUMN iot_name         format a10 heading 'IOT|Overflow'
COLUMN iot_type         format a12 heading 'IOT or|Overflow'
COLUMN nested           format a6  heading 'Nested'
SET lines 130 verify off feedback off pages 58
START title132 'Extended Table Report'
SPOOL rep_out\tab_rep
SELECT owner, table_name, tablespace_name, iot_name, LOGGING, partitioned,
       iot_type, TEMPORARY, NESTED
  FROM dba_tables
 WHERE owner LIKE UPPER ('%&owner%');
SPOOL off
SET verify on lines 80 pages 22 feedback on
TTITLE OFF
