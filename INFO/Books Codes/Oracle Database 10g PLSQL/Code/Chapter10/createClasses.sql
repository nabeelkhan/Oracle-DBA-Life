/*
 * createClasses.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script builds the CLASSES table.
 */

SET ECHO ON

BEGIN
  FOR i IN (SELECT   null
            FROM     user_tables
            WHERE    table_name = 'CLASSES') LOOP
    FOR j IN (SELECT   null
              FROM     user_tables
              WHERE    table_name = 'REGISTERED_STUDENTS') LOOP
      EXECUTE IMMEDIATE 'DROP TABLE registered_students';
    END LOOP;
    EXECUTE IMMEDIATE 'DROP TABLE classes';
  END LOOP;
END;
/

CREATE TABLE classes (
  department            CHAR(3)      NOT NULL,
  course                NUMBER(3)    NOT NULL,
  current_students      NUMBER(3)    NOT NULL,
  num_credits           NUMBER(1)    NOT NULL,
  name                  VARCHAR2(40) NOT NULL,
  CONSTRAINT classes_pk PRIMARY KEY (department,course));
