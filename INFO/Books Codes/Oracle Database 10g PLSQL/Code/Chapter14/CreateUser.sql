/*
 * CreateUser.sql
 * Chapter 14 & 15, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script creates the objects_user for chapters 14
 *   and 15 examples.  You must run this script as SYS or
 *   SYSTEM as SYSDBA.  The script can be rerun.
 *
 * objects_user is created using the USERS and TEMP tablespace.
 *   If these tablespaces do not exist in your environment, change
 *   the script to use an appropriate tablespace.
 *
 * Modify the conn_string value below, providing your Net Service
 *   Name if not using your default.
 */

DEF conn_string = objects_user/oracle
DEF username = OBJECTS_USER
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
   EXECUTE IMMEDIATE ('GRANT execute ON ctx_ddl TO &username');
   EXECUTE IMMEDIATE ('GRANT execute ON utl_ref TO &username');
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

CONN &conn_string

CREATE OR REPLACE PACKAGE clean_schema IS

   PROCEDURE synonyms;
   PROCEDURE tables;
   PROCEDURE objects;
 
END;
/


CREATE OR REPLACE PACKAGE BODY clean_schema AS

PROCEDURE synonyms
IS
   v_string VARCHAR2(50);
   v_syn_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_syn_error, -1434); 
BEGIN
   v_string := 'DROP SYNONYM soft_cover_syn';
   EXECUTE IMMEDIATE (v_string);
EXCEPTION
   WHEN v_syn_error
      THEN
      NULL;
END synonyms;

PROCEDURE tables
IS
   v_string VARCHAR2(50);
   v_tab_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_tab_error, -942); 
BEGIN
   BEGIN
   v_string := 'DROP VIEW inventory_vie';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP VIEW book_vie';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP TABLE soft_cover_tbl';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP TABLE hard_cover_tbl';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP TABLE book_tbl';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP TABLE inventory_tbl';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP TABLE discount_price_tbl';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP TABLE publisher_tbl';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP TABLE cd_tbl';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP TABLE music_tbl';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;
END TABLES;

PROCEDURE objects 
IS
   v_string VARCHAR2(50);
   v_obj_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_obj_error, -4043); 
BEGIN
   BEGIN
   v_string := 'drop type soft_cover_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'drop type hard_cover_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'drop type book_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'drop type cd_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'drop type music_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'drop type music_person_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'drop type publisher_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'drop type contact_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'drop type address_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'drop type person_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'drop type inventory_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'drop type discount_price_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'drop type abbrev_book_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'drop type abbrev_inventory_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

END objects;

END;
/


