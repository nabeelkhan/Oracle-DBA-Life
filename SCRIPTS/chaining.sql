REM FILE NAME:  chaining.sql
REM LOCATION:   Object Management\Tables\Reports
REM FUNCTION:   Report on the number of CHAINED rows within a named table 
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   v$statname, v$session, dba_tab_columns, sys.col$, sys.obj$, sys.icol$, 
REM                      sys.user$, v$sesstat, dual
REM
REM This is a part of the Knowledge Xpert for Oracle Administration library. 
REM Copyright (C) 2001 Quest Software 
REM All rights reserved. 
REM 
REM******************** Knowledge Xpert for Oracle Administration ********************
REM
REM  NOTES:  Requires DBA priviledges.
REM          The target table must have a column that is the leading portion
REM              of an index and is defined as not null.
REM          Uses the V$SESSTAT table where USERNAME is the current user.
REM              A problem if > 1 session active with that USERID.
REM          The statistics in V$SESSTAT may change between releases and
REM              platforms.  Make sure that 'table fetch continued row' is
REM              a valid statistic.
REM          This routine can be run by AUTO_CHN.sql by remarking the two
REM              accepts and un-remarking the two defines.
REM

REM
REM***********************************************************************************


ACCEPT obj_own prompt 'Enter the table owner''s name: '
ACCEPT obj_nam prompt 'Enter the name of the table: '
REM DEFINE obj_own = &1
REM DEFINE obj_nam = &2
SET termout off feedback off verify off echo off heading off embedded on
REM  Find out what statistic we want
COLUMN statistic# new_value stat_no 
SELECT statistic#
  FROM v$statname n
 WHERE n.NAME = 'table fetch continued row'
/



REM  Find out who we are in terms of sid
COLUMN sid new_value user_sid 
SELECT DISTINCT sid
           FROM v$session
          WHERE audsid = USERENV ('SESSIONID')
/



REM  Find the last col of the table and a not null indexed column
COLUMN column_name new_value last_col 
COLUMN name new_value indexed_column 
COLUMN value new_value before_count 
SELECT   column_name
    FROM dba_tab_columns
   WHERE table_name = UPPER ('&&obj_nam') AND owner = UPPER ('&&obj_own')
ORDER BY column_id
/


SELECT c.NAME
  FROM sys.col$ c, sys.obj$ idx, sys.obj$ base, sys.icol$ ic
 WHERE base.obj# = c.obj#
   AND ic.bo# = base.obj#
   AND ic.col# = c.col#
   AND base.owner# =
                (SELECT user#
                   FROM sys.user$
                  WHERE NAME = UPPER ('&&obj_own'))
   AND ic.obj# = idx.obj#
   AND base.NAME = UPPER ('&&obj_nam')
   AND ic.pos# = 1
   AND c.null$ > 0
/


SELECT VALUE
  FROM v$sesstat
 WHERE v$sesstat.sid = &user_sid AND v$sesstat.statistic# = &stat_no
/



REM  Select every row from the target table
SELECT &last_col xx
  FROM &obj_own..&obj_nam
 WHERE &indexed_column <=
                         (SELECT MAX (&indexed_column)
                            FROM &obj_own..&obj_nam)
/



COLUMN value new_value after_count 
SELECT VALUE
  FROM v$sesstat
 WHERE v$sesstat.sid = &user_sid AND v$sesstat.statistic# = &stat_no
/



SET termout on
SELECT    'Table '
       || UPPER ('&obj_own')
       || '.'
       || UPPER ('&obj_nam')
       || ' contains '
       || (  TO_NUMBER (&after_count)
           - TO_NUMBER (&before_count)
          )
       || ' chained row'
       || DECODE (
               TO_NUMBER (&after_count)
             - TO_NUMBER (&before_count),
             1, '.',
             's.'
          )
  FROM DUAL
 WHERE RTRIM ('&indexed_column') IS NOT NULL
/



REM If we don't have an indexed column this won't work so say so
SELECT    'Table '
       || UPPER ('&obj_own')
       || '.'
       || UPPER ('&obj_nam')
       || ' has no indexed, not null columns.'
  FROM DUAL
 WHERE RTRIM ('&indexed_column') IS NULL
/

SET termout on feedback 15 verify on pagesize 20 linesize 80 space 1 heading on
UNDEF obj_nam
UNDEF obj_own
UNDEF before_count
UNDEF after_count
UNDEF indexed_column
UNDEF last_col
UNDEF stat_no
UNDEF user_sid
CLEAR columns
CLEAR computes
