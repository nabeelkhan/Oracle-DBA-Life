/*
 * createStudents.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script builds the STUDENT table.
 */

SET ECHO ON

BEGIN
  FOR i IN (SELECT   null
            FROM     user_tables
            WHERE    table_name = 'STUDENTS') LOOP
    FOR j IN (SELECT   null
              FROM     user_tables
              WHERE    table_name = 'REGISTERED_STUDENTS') LOOP
      EXECUTE IMMEDIATE 'DROP TABLE registered_students';
    END LOOP;
    EXECUTE IMMEDIATE 'DROP TABLE students';
  END LOOP;
END;
/

CREATE TABLE students (
  id                         NUMBER(5)    NOT NULL,
  current_credits            NUMBER(2),
  major                      VARCHAR2(20),
  last_name                  VARCHAR2(20) NOT NULL,
  first_name                 VARCHAR2(20) NOT NULL,
  middle_initial             VARCHAR2(1),
  CONSTRAINT students_pk     PRIMARY KEY (id));
