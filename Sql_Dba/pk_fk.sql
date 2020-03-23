REM FILE NAME:  pk_fk.sql
REM LOCATION:   Object Management\Indexes\Reports
REM FUNCTION:   SCRIPT FOR DOCUMENTING DATABASE KEYS
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1
REM PLATFORM:   non-specific
REM REQUIRES:   user_constraints, user_cons_columns
REM
REM  This is a part of the Oracle DB Admin Module By Nabeel Khan for Dealer V
REM  Ref:Oracle Administration library. 
REM  Copyright (C) 2002 ZANS Solutions
REM  All rights reserved. 
REM 
REM******************** Oracle DB Admin Module for Dealer V ********************
REM
REM  NOTES:   This script must be run by the KEY owner.  
REM 
REM           This script is intended to run with Oracle7 or higher.
REM
REM           Running this script will in turn create a report on 
REM           primary keys and their related foreign keys
REM 
REM***********************************************************************************


SET arraysize 1 
SET verify off
REM set feedback off
REM set termout off
REM set echo off
SET pagesize 0
SET long 4000
SET termout on
SELECT 'Creating Primary/Foreign Key Report...'
  FROM DUAL;
REM set termout off

CREATE TABLE cons_temp (owner VARCHAR2(30),
                        constraint_name VARCHAR2(30),
                        constraint_type VARCHAR2(11),
                        search_condition VARCHAR2(2000),
                        table_name VARCHAR2(30),
                        referenced_owner VARCHAR2(30),
                        referenced_constraint VARCHAR2(30),
                        delete_rule VARCHAR2(9),
                        constraint_columns VARCHAR2(2000),
                        con_number NUMBER);
TRUNCATE TABLE cons_temp;

DECLARE
   CURSOR cons_cursor
   IS
      SELECT   owner, constraint_name,
               DECODE (
                  constraint_type,
                  'P', 'Primary Key',
                  'R', 'Foreign Key',
                  'U', 'Unique',
                  'C', 'Check',
                  'D', 'Default'
               ),
               search_condition, table_name, r_owner, r_constraint_name,
               delete_rule
          FROM user_constraints
         WHERE owner NOT IN ('SYS', 'SYSTEM')
      ORDER BY owner;

   CURSOR cons_col (cons_name IN VARCHAR2)
   IS
      SELECT   owner, constraint_name, column_name
          FROM user_cons_columns
         WHERE owner NOT IN ('SYS', 'SYSTEM')
           AND constraint_name = UPPER (cons_name)
      ORDER BY owner, constraint_name, position;

   CURSOR get_cons (tab_nam IN VARCHAR2)
   IS
      SELECT DISTINCT owner, table_name, constraint_name, constraint_type
                 FROM cons_temp
                WHERE table_name = tab_nam AND constraint_type =
                                                                'Foreign Key'
             ORDER BY owner, table_name, constraint_name;

   CURSOR get_tab_nam
   IS
      SELECT DISTINCT table_name
                 FROM cons_temp
                WHERE constraint_type = 'Foreign Key'
             ORDER BY table_name;

   tab_nam          user_constraints.table_name%TYPE;
   cons_owner       user_constraints.owner%TYPE;
   cons_name        user_constraints.constraint_name%TYPE;
   cons_type        VARCHAR2 (11);
   cons_sc          user_constraints.search_condition%TYPE;
   cons_tname       user_constraints.table_name%TYPE;
   cons_rowner      user_constraints.r_owner%TYPE;
   cons_rcons       user_constraints.r_constraint_name%TYPE;
   cons_dr          user_constraints.delete_rule%TYPE;
   cons_col_own     user_cons_columns.owner%TYPE;
   cons_col_nam     user_cons_columns.constraint_name%TYPE;
   cons_column      user_cons_columns.column_name%TYPE;
   cons_tcol_name   user_cons_columns.table_name%TYPE;
   all_columns      VARCHAR2 (2000);
   counter          INTEGER                                   := 0;
   cons_nbr         INTEGER;
BEGIN
   OPEN cons_cursor;

   LOOP
      FETCH cons_cursor INTO cons_owner,
                             cons_name,
                             cons_type,
                             cons_sc,
                             cons_tname,
                             cons_rowner,
                             cons_rcons,
                             cons_dr;
      EXIT WHEN cons_cursor%NOTFOUND;
      all_columns := '';
      counter := 0;
      OPEN cons_col (cons_name);

      LOOP
         FETCH cons_col INTO cons_col_own, cons_col_nam, cons_column;
         EXIT WHEN cons_col%NOTFOUND;

         IF  cons_owner = cons_col_own AND cons_name = cons_col_nam
         THEN
            counter :=   counter
                       + 1;

            IF counter = 1
            THEN
               all_columns :=    all_columns
                              || cons_column;
            ELSE
               all_columns :=    all_columns
                              || ', '
                              || cons_column;
            END IF;
         END IF;
      END LOOP;

      CLOSE cons_col;

      INSERT INTO cons_temp
           VALUES (cons_owner, cons_name, cons_type, cons_sc, cons_tname, cons_rowner, cons_rcons, cons_dr, all_columns, 0);

      COMMIT;
   END LOOP;

   CLOSE cons_cursor;
   COMMIT;

   BEGIN
      OPEN get_tab_nam;

      LOOP
         FETCH get_tab_nam INTO tab_nam;
         EXIT WHEN get_tab_nam%NOTFOUND;
         /*sys.dbms_output.put_line(tab_nam);*/
         OPEN get_cons (tab_nam);
         cons_nbr := 0;

         LOOP
            FETCH get_cons INTO cons_owner, cons_tname, cons_name, cons_type;
            EXIT WHEN get_cons%NOTFOUND;
            cons_nbr :=   cons_nbr
                        + 1;

            /*    sys.dbms_output.put_line('cons_nbr='||cons_nbr);*/
            /*sys.dbms_output.put_line(cons_owner||'.'||cons_name||' '||cons_type);*/
            UPDATE cons_temp
               SET con_number = cons_nbr
             WHERE constraint_name = cons_name
               AND constraint_type = cons_type
               AND owner = cons_owner;
         END LOOP;

         CLOSE get_cons;
         COMMIT;
      END LOOP;

      CLOSE get_tab_nam;
      COMMIT;
   END;
END;
/

CREATE INDEX pk_cons_temp ON cons_temp(constraint_name);

CREATE INDEX lk_cons_temp2 ON cons_temp(referenced_constraint);
SET feedback off pages 0 termout off echo off
SET verify off
SET pages 48 lines 132
COLUMN pri_own format a9  heading 'Pri Table|Owner'
COLUMN for_own format a9  heading 'For Table|Owner'
COLUMN pri_tab format a14 heading 'Pri Table|Name'
COLUMN for_tab format a14 heading 'For Table|Name'
COLUMN pri_col format a19 heading 'Pri Key|Columns' word_wrapped
COLUMN for_col format a19 heading 'For Key|Columns' word_wrapped
START title132 'Primary Key - Foreign Key Report'
SPOOL rep_out\pk_fk
BREAK on a.owner on a.table_name on b.owner on b.table_name
SELECT   b.owner pri_own, b.table_name pri_tab,
         RTRIM (b.constraint_columns) pri_col, a.owner for_own,
         a.table_name for_tab, RTRIM (a.constraint_columns) for_col
    FROM cons_temp a, cons_temp b
   WHERE a.referenced_constraint = b.constraint_name
ORDER BY 1, 2, 4, 5;
SPOOL off
DROP TABLE cons_temp;
