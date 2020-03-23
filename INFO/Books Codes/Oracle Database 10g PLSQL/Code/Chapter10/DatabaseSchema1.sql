/*
 * DatabaseSchema1.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined triggers.
 */

SET ECHO ON
SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  wrong_schema EXCEPTION;
  PRAGMA EXCEPTION_INIT(wrong_schema,-20001);

  retval VARCHAR2(1 CHAR);

  CURSOR privs IS
    SELECT   DISTINCT null
    FROM     user_role_privs
    WHERE    username = 'SYSTEM'
    OR       granted_role = 'DBA';

BEGIN
  OPEN privs;
  LOOP
    FETCH privs INTO retval;
    IF privs%NOTFOUND THEN
      RAISE wrong_schema;
      EXIT;
    ELSE
      EXECUTE IMMEDIATE
        'CREATE USER UserA IDENTIFIED BY UserA';
      EXECUTE IMMEDIATE
        'GRANT connect, resource, ADMINISTER DATABASE TRIGGER TO UserA';
      EXECUTE IMMEDIATE
        'CREATE USER UserB IDENTIFIED BY UserB';
      EXECUTE IMMEDIATE
        'GRANT connect, resource, ADMINISTER DATABASE TRIGGER TO UserB';
      EXECUTE IMMEDIATE
        'GRANT ADMINISTER DATABASE TRIGGER TO example';
    END IF; 
  END LOOP;
EXCEPTION
  WHEN wrong_schema THEN
    DBMS_OUTPUT.PUT_LINE('The script requires the SYSTEM user and '
    ||                   'you are using the <'||user||'> schema or '
    ||                   'the script requires a user with DBA role '
    ||                   'privileges.');
  WHEN others THEN
    RETURN;
END;
/


connect example/example

BEGIN
  FOR i IN (SELECT   null
            FROM     user_tables
            WHERE    table_name = 'TEMP_TABLE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE temp_table';
  END LOOP;
END;
/

CREATE TABLE temp_table (
  num_col    NUMBER,
  char_col   VARCHAR2(200)
  );

GRANT SELECT, UPDATE, INSERT ON temp_table TO usera;
GRANT SELECT, UPDATE, INSERT ON temp_table TO userb;

connect UserA/UserA
CREATE OR REPLACE TRIGGER LogUserAConnects
  AFTER LOGON ON SCHEMA
BEGIN
  INSERT INTO example.temp_table
    VALUES (1, 'LogUserAConnects fired!');
END LogUserAConnects;
/
show errors

connect UserB/UserB
CREATE OR REPLACE TRIGGER LogUserBConnects
  AFTER LOGON ON SCHEMA
BEGIN
  INSERT INTO example.temp_table
    VALUES (2, 'LogUserBConnects fired!');
END LogUserBConnects;
/
show errors


connect example/example
CREATE OR REPLACE TRIGGER LogAllConnects
  AFTER LOGON ON DATABASE
BEGIN
  INSERT INTO example.temp_table
    VALUES (3, 'LogAllConnects fired!');
END LogAllConnects;
/
show errors

