REM FILE NAME:  rowsize.sql
REM LOCATION:   Object Management\Tables\Utilities
REM FUNCTION:   Compute the average row size for a table.
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tab_columns
REM
REM INPUTS:		tname  = Name of table.
REM         	towner = Name of owner of table.
REM         	cfile  = Name of output SQL Script file
REM  
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************


COLUMN dum1     NOPRINT
COLUMN rowcount new_value countrow noprint
COLUMN strcount new_value strct noprint
COLUMN rsize    FORMAT 99,999.99
COLUMN rcount   FORMAT 999,999,999 newline 
ACCEPT tname  PROMPT 'Enter table name: '
ACCEPT towner PROMPT 'Enter owner name: '
SET PAGESIZE 999  HEADING OFF  VERIFY OFF  TERMOUT OFF
SET FEEDBACK OFF  SQLCASE UPPER  NEWPAGE 3
SELECT COUNT (*) ROWCOUNT
  FROM &&towner..&&tname;
SELECT TO_CHAR (&&countrow) strcount
  FROM DUAL;
DEFINE qt=chr(39)
SPOOL rep_out\rowsize.sql
SELECT 0 dum1,
          'SELECT '
       || &&qt
       || 'Table &&towner..&&tname has &&strct rows of '
       || &&qt
       || ', ('
  FROM &&towner..&&tname
UNION
SELECT column_id,    'SUM(NVL(VSIZE('
                  || column_name
                  || '),0)) + 1 +'
  FROM dba_tab_columns
 WHERE table_name = UPPER ('&&tname')
   AND owner = UPPER ('&&towner')
   AND column_id <> (SELECT MAX (column_id)
                       FROM dba_tab_columns
                      WHERE table_name = UPPER ('&&tname')
                        AND owner = UPPER ('&&towner'))
UNION
SELECT column_id,    'SUM(NVL(VSIZE('
                  || column_name
                  || '),0)) + 1)'
  FROM dba_tab_columns
 WHERE table_name = UPPER ('&&tname')
   AND owner = UPPER ('&&towner')
   AND column_id = (SELECT MAX (column_id)
                      FROM dba_tab_columns
                     WHERE table_name = UPPER ('&&tname')
                       AND owner = UPPER ('&&towner'))
UNION
SELECT 997, '/ COUNT(*) + 5 rsize, '' bytes each.'''
  FROM DUAL
UNION
SELECT 999, 'from &&towner..&&tname.;'
  FROM DUAL;
SPOOL OFF
SET TERMOUT ON  FEEDBACK 15   PAGESIZE 20   
SET SQLCASE MIXED   NEWPAGE 1
START rep_out\rowsize.sql
CLEAR COLUMNS
UNDEF cfile
UNDEF tname
UNDEF towner
