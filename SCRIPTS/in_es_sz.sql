REM FILE NAME: 	in_es_sz.sql
REM LOCATION:   Object Management\Indexes\Utilities
REM FUNCTION:  	Compute the space used by an entry for an 
REM             existing index.
REM TESTED ON: 	8.1.5, 8.1.7, 9.0.1
REM
REM INPUTS:   	tname  = Name of table.
REM            	towner = Name of owner of table.
REM            	clist  = List of columns enclosed in quotes.
REM                      i.e 'ename', 'empno'
REM  
REM  This is a part of the Knowledge Xpert for Oracle Administration library. 
REM  Copyright (C) 2001 Quest Software 
REM  All rights reserved. 
REM
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM  NOTES:  Currently requires DBA.
REM
REM***********************************************************************************
REM 

COLUMN name NEW_VALUE   db NOPRINT
COLUMN rowcount new_value countrow noprint
COLUMN strcount new_value strct noprint
COLUMN col_id noprint
COLUMN dum1    NOPRINT
COLUMN isize   FORMAT 99,999.99
COLUMN rcount  FORMAT 999,999,999 newline 
ACCEPT tname  PROMPT 'Enter table name: '
ACCEPT towner PROMPT 'Enter table owner name: '
ACCEPT clist  PROMPT 'Enter column list: '
SELECT COUNT (*) ROWCOUNT
  FROM &&towner..&&tname;
SELECT TO_CHAR (&&countrow) strcount
  FROM DUAL;
DEFINE qt=chr(39);

SET PAGESIZE 999 HEADING OFF VERIFY OFF TERMOUT OFF 
SET FEEDBACK OFF SQLCASE UPPER
SET NEWPAGE 3 

SELECT NAME
  FROM v$database;
SPOOL rep_out/in_es_sz.sql

SELECT   0 dum1,
            'SELECT '
         || &&qt
         || 'Proposed Index on table &&towner..&&tname has &&strct rows of '
         || &&qt
         || '||'
    FROM DUAL
UNION
SELECT   1 dum1, 'TO_CHAR(CEIL(('
    FROM DUAL
UNION
SELECT     column_id
         + 1 col_id,
            'SUM(NVL(vsize('
         || column_name
         || '),0)) + 1 +'
    FROM dba_tab_columns
   WHERE table_name = UPPER ('&tname')
     AND owner = UPPER ('&towner')
     AND column_name IN (&&clist)
     AND column_id <> (SELECT MAX (column_id)
                         FROM dba_tab_columns
                        WHERE table_name = UPPER ('&tname')
                          AND owner = UPPER ('&towner')
                          AND column_name IN (&&clist))
UNION
SELECT     column_id
         + 1 col_id,    'SUM(NVL(VSIZE('
                     || column_name
                     || '),0)) + 1'
    FROM dba_tab_columns
   WHERE table_name = UPPER ('&tname')
     AND owner = UPPER ('&towner')
     AND column_name IN (&&clist)
     AND column_id = (SELECT MAX (column_id)
                        FROM dba_tab_columns
                       WHERE table_name = UPPER ('&tname')
                         AND owner = UPPER ('&towner')
                         AND column_name IN (&&clist))
UNION
SELECT   997,    ')/ COUNT(*) + 11))'
              || '||'
              || &&qt
              || ' bytes each.'
              || &&qt
    FROM DUAL
UNION
SELECT   999, 'FROM &towner..&tname.;'
    FROM DUAL
ORDER BY 1
/
SPOOL OFF
SET TERMOUT ON FEEDBACK 15 PAGESIZE 20 SQLCASE MIXED 
SET NEWPAGE 1
SPOOL rep_out\in_es_sz
START rep_out\in_es_sz.sql
SPOOL OFF
CLEAR COLUMNS
UNDEF towner
UNDEF tname
UNDEF clist
