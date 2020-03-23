/*
 * CreateUser.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This script creates the plsql user for chapter 3
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
   EXECUTE IMMEDIATE ('GRANT execute ON utl_ref TO &username');
   EXECUTE IMMEDIATE ('GRANT create trigger TO &username');
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

   PROCEDURE trigs;
   PROCEDURE tables;
   PROCEDURE procs;
 
END;
/


CREATE OR REPLACE PACKAGE BODY clean_schema AS

PROCEDURE trigs
IS
   v_string VARCHAR2(50);
   v_tab_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_tab_error, -4080); 
BEGIN

   BEGIN
   v_string := 'DROP TRIGGER author_trig';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

END trigs;


PROCEDURE tables
IS
   v_string VARCHAR2(50);
   v_tab_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_tab_error, -942); 
BEGIN

   BEGIN
   v_string := 'DROP TABLE precision';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

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

PROCEDURE procs
IS
   v_string VARCHAR2(50);
   v_proc_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_proc_error, -4043);
BEGIN
   BEGIN
   v_string := 'DROP PROCEDURE compile_error';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PROCEDURE compile_warning';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PROCEDURE named_block';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PROCEDURE book_ins';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PROCEDURE authors_sel';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PROCEDURE bind_test';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PROCEDURE author_book_count';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

END procs;

END;
/


spool off
