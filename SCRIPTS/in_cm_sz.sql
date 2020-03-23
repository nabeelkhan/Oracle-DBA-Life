REM FILE NAME:  in_cm_sz.sql
REM LOCATION:   Object Management\Indexes\Utilities
REM FUNCTION:   Compute the space used by an entry for an existing index
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   dba_tab_columns, dual
REM
REM INPUTS:		tname 	= Name of table
REM				towner	= Name of owner of table
REM				iname	= Name of index
REM				iowner 	= Name of owner of index
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


COLUMN dum1     NOPRINT
COLUMN rowcount new_value countrow noprint
COLUMN strcount new_value strct noprint
COLUMN isize    FORMAT 99,999.99
COLUMN rcnt     FORMAT 999,999,999      
ACCEPT tname  PROMPT 'Enter table name: '
ACCEPT towner PROMPT 'Enter table owner name: '
ACCEPT iname  PROMPT 'Enter index name: '
ACCEPT iowner PROMPT 'Enter index owner name: '
SELECT COUNT (*) ROWCOUNT
  FROM &&towner..&&tname;
SELECT TO_CHAR (&&countrow) strcount
  FROM DUAL;
DEFINE qt=chr(39)
DEFINE cr='chr(10)'
SET PAGESIZE 999 HEADING OFF VERIFY OFF TERMOUT OFF EMBEDDED ON
SET FEEDBACK OFF LINES 70
SET SQLCASE UPPER NEWPAGE 3
SPOOL rep_out\in_cm_sz.sql
SELECT -1 dum1,
          'SELECT '
       || &&qt
       || 'Proposed Index on table  &&towner..&&tname has &&strct rows of '
       || &&qt
       || ', ('
  FROM &&towner..&&tname
UNION
SELECT column_id,    'SUM(NVL(vsize('
                  || column_name
                  || '),0)) + 1 +'
  FROM dba_tab_columns
 WHERE table_name = '&tname'
   AND owner = '&towner'
   AND column_name IN (SELECT column_name
                         FROM dba_ind_columns
                        WHERE table_name = UPPER ('&tname')
                          AND table_owner = UPPER ('&towner')
                          AND index_name = UPPER ('&iname')
                          AND index_owner = UPPER ('&iowner'))
   AND column_id <> (SELECT MAX (column_id)
                       FROM dba_tab_columns
                      WHERE table_name = UPPER ('&tname')
                        AND owner = UPPER ('&towner')
                        AND column_name IN (SELECT column_name
                                              FROM dba_ind_columns
                                             WHERE table_name =
                                                              UPPER ('&tname')
                                               AND table_owner =
                                                             UPPER ('&towner')
                                               AND index_name =
                                                              UPPER ('&iname')
                                               AND index_owner =
                                                             UPPER ('&iowner')))
UNION
SELECT column_id,    'SUM(NVL(vsize('
                  || column_name
                  || '),0)) + 1)'
  FROM dba_tab_columns
 WHERE table_name = UPPER ('&tname')
   AND owner = UPPER ('&towner')
   AND column_name IN (SELECT column_name
                         FROM dba_ind_columns
                        WHERE table_name = UPPER ('&tname')
                          AND table_owner = UPPER ('&towner')
                          AND index_name = UPPER ('&iname')
                          AND index_owner = UPPER ('&iowner'))
   AND column_id = (SELECT MAX (column_id)
                      FROM dba_tab_columns
                     WHERE table_name = UPPER ('&tname')
                       AND owner = UPPER ('&towner')
                       AND column_name IN (SELECT column_name
                                             FROM dba_ind_columns
                                            WHERE table_name =
                                                              UPPER ('&tname')
                                              AND table_owner =
                                                             UPPER ('&towner')
                                              AND index_name =
                                                              UPPER ('&iname')
                                              AND index_owner =
                                                             UPPER ('&iowner')))
UNION
SELECT 997, '/ COUNT(*) + 11 isize, '' bytes each.'''
  FROM DUAL
UNION
SELECT 999, 'FROM &towner..&tname.;'
  FROM DUAL;
SPOOL OFF
SET TERMOUT ON FEEDBACK 15 PAGESIZE 20 SQLCASE MIXED 
SET NEWPAGE 1
SPOOL rep_out\in_cm_sz
START rep_out\in_cm_sz.sql
SPOOL OFF
CLEAR columns
UNDEF tname
UNDEF towner
UNDEF iname
UNDEF iowner
