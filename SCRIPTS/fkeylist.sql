REM FILE NAME:  fkeylist.sql
REM LOCATION:   Object Management\Indexes\Reports
REM FUNCTION:   prints a report of all foreign keys defined in the data dictionary 
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   DBA_CONSTRAINTS, DBA_CONS_COLUMNS
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


SET LINES 130 PAGES 56
REM
COLUMN OWNER               FORMAT A10  NOPRINT NEW_VALUE OWNER_VAR
COLUMN TABLE_NAME          FORMAT A24  HEADING'TABLE NAME'
COLUMN REF_TABLE           FORMAT A24  HEADING'REF TABLE'
COLUMN R_OWNER             FORMAT A10  NOPRINT
COLUMN CONSTRAINT_NAME     FORMAT A30  HEADING 'CONST NAME'
COLUMN R_CONSTRAINT_NAME   FORMAT A30  NOPRINT
COLUMN COLUMN_NAME         FORMAT A20  HEADING'COLUMN'
COLUMN REF_COLUMN          FORMAT A20  HEADING'REF COLUMN'
REM
START title132 "FOREIGN KEY REPORT"
REM
BREAK ON OWNER SKIP PAGE ON TABLE_NAME SKIP 1 -
            ON CONSTRAINT_NAME ON REF_TABLE
SPOOL rep_out\fkeylist
REM
SELECT   c.owner, c.table_name, c.constraint_name, cc.column_name,
         r.table_name ref_table, rc.column_name ref_column
    FROM dba_constraints c,
         dba_constraints r,
         dba_cons_columns cc,
         dba_cons_columns rc
   WHERE c.constraint_type = 'R'
     AND c.owner NOT IN ('SYS', 'SYSTEM')
     AND c.r_owner = r.owner
     AND c.r_constraint_name = r.constraint_name
     AND c.constraint_name = cc.constraint_name
     AND c.owner = cc.owner
     AND r.constraint_name = rc.constraint_name
     AND r.owner = rc.owner
     AND cc.position = rc.position
ORDER BY C.owner, C.table_name, C.constraint_name, cc.position;
SPOOL OFF
CLEAR breaks
CLEAR columns
TTITLE off
SET lines 80 pages 22
