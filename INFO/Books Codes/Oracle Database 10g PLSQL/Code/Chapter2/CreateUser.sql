/*
 * CreateUser.sql
 * Chapter 2, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This script creates the plsql user for chapter 2
 *   examples.  You must run this script as SYS or
 *   SYSTEM as SYSDBA.  The script can be rerun.
 *
 * The plsql user is created using the USERS and TEMP tablespace.
 *   If these tablespaces do not exist in your environment, change
 *   the script to use an appropriate tablespace.
 *
 * Modify the conn_string value below, providing your Net Service
 *   Name if not using your default.
 */

DEF conn_string = plsql/oracle
DEF username = plsql
DEF default_ts = USERS
DEF temp_ts = TEMP

SET FEEDBACK OFF SERVEROUTPUT ON VERIFY OFF TERMOUT OFF

SPOOL CreateUser.log

DECLARE
   v_count       INTEGER        := 0;
   v_statement   VARCHAR2 (200);
BEGIN
   SELECT COUNT (1)
     INTO v_count
     FROM dba_users
    WHERE username = UPPER ('&username');

   IF v_count != 0
   THEN
      EXECUTE IMMEDIATE ('DROP USER &username CASCADE');
   END IF;

   v_statement :=
         'CREATE USER &username IDENTIFIED BY oracle'
      || ' DEFAULT TABLESPACE &default_ts'
      || ' TEMPORARY TABLESPACE &temp_ts'
      || ' QUOTA UNLIMITED ON &default_ts'
      || ' ACCOUNT UNLOCK';

   EXECUTE IMMEDIATE (v_statement);

   -- Grant permissions
   EXECUTE IMMEDIATE ('GRANT create session TO &username');
   EXECUTE IMMEDIATE ('GRANT connect TO &username');
   EXECUTE IMMEDIATE ('GRANT create procedure TO &username');
   EXECUTE IMMEDIATE ('GRANT create trigger TO &username');
   EXECUTE IMMEDIATE ('GRANT debug connect session TO &username');
   EXECUTE IMMEDIATE ('GRANT debug any procedure TO &username');
   EXECUTE IMMEDIATE ('GRANT resource TO &username');

   DBMS_OUTPUT.put_line ('	');
   DBMS_OUTPUT.put_line ('User &username created successfully');
   DBMS_OUTPUT.put_line ('	');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLERRM);
      DBMS_OUTPUT.put_line ('	');
END;
/

SET FEEDBACK ON TERMOUT ON

PROMPT
PROMPT ******** Connecting to user &username!! ********
PROMPT

CONN &conn_string

CREATE OR REPLACE PACKAGE clean_schema IS

   PROCEDURE triggers;
   PROCEDURE tables;
   PROCEDURE procedures;

END;
/


CREATE OR REPLACE PACKAGE BODY clean_schema AS

PROCEDURE triggers
IS
   v_string VARCHAR2(50);
   v_trig_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_trig_error, -4080); 
BEGIN
   v_string := 'DROP TRIGGER author_trig';
   EXECUTE IMMEDIATE (v_string);
EXCEPTION
   WHEN v_trig_error
      THEN
      NULL;
END triggers;

PROCEDURE tables
IS
   v_string VARCHAR2(50);
   v_tab_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_tab_error, -942); 
BEGIN

   BEGIN
      v_string := 'DROP TABLE inventory';
      EXECUTE IMMEDIATE (v_string);
   EXCEPTION
      WHEN v_tab_error
         THEN
         NULL;
   END;

   BEGIN
      v_string := 'DROP TABLE books';
      EXECUTE IMMEDIATE (v_string);
   EXCEPTION
      WHEN v_tab_error
         THEN
         NULL;
   END;

   BEGIN
      v_string := 'DROP TABLE authors';
      EXECUTE IMMEDIATE (v_string);
   EXCEPTION
      WHEN v_tab_error
         THEN
         NULL;
   END;

END TABLES;

PROCEDURE procedures
IS
   v_string VARCHAR2(50);
   v_proc_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_proc_error, -4043); 
BEGIN

   BEGIN
      v_string := 'DROP PROCEDURE author_books_sel';
      EXECUTE IMMEDIATE (v_string);
   EXCEPTION
      WHEN v_proc_error
         THEN
         NULL;
   END;

   BEGIN
      v_string := 'DROP PROCEDURE author_first_name_upd';
      EXECUTE IMMEDIATE (v_string);
   EXCEPTION
      WHEN v_proc_error
         THEN
         NULL;
   END;

END procedures;

END;
/


spool off
