REM FILE NAME:  pkey.sql
REM LOCATION:   Object Management\Indexes\Reports
REM FUNCTION:   Report of all primary keys (other than those owned by 
REM             SYS and SYSTEM)
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_constraints, dba_cons_columns
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM NOTES:      As written, it must be run by a DBA.  By changing the 
REM             query to run against ALL_CONSTRAINTS, etc. it could be 
REM             used by any user to see the primary keys which are 
REM             "available" to them.
REM
REM INPUTS:     Owner for tables
REM
REM***********************************************************************************


ACCEPT OWNER PROMPT 'ENTER OWNER NAME OR "ALL" '
REM
COLUMN OWNER            FORMAT A15  NOPRINT NEW_VALUE OWNER_VAR
COLUMN TABLE_NAME       FORMAT A25      HEADING 'Table Name'
COLUMN CONSTRAINT_NAME  FORMAT A20      HEADING 'Constraint Name'
COLUMN COLUMN_NAME      FORMAT A25      HEADING' Column Name'
REM
BREAK ON OWNER SKIP PAGE ON TABLE_NAME SKIP 1 ON CONSTRAINT_NAME
REM
START title80 "Primary Keys For Database Tables"
SPOOL rep_out\pkey
REM
SELECT   c.owner, c.table_name, c.constraint_name, cc.column_name
    FROM dba_constraints c, dba_cons_columns cc
   WHERE c.constraint_name = cc.constraint_name
     AND c.owner = cc.owner
     AND c.constraint_type = 'P'
     AND c.owner <> 'SYS'
     AND c.owner <> 'SYSTEM'
     AND c.owner LIKE UPPER ('%&&OWNER%')
ORDER BY C.owner, C.table_name, cc.position;
SPOOL OFF
UNDEF OWNER
TTITLE OFF
