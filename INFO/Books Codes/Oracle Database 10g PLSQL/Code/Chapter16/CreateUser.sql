/*
 * CreateUser.sql
 * Chapter 16, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script creates the lob_user for chapter 16
 *   You must run this script as SYS or
 *   SYSTEM as SYSDBA.  The script can be rerun.
 *
 * lob_user is created using the USERS and TEMP tablespace.
 *   If these tablespaces do not exist in your environment, change
 *   the script to use an appropriate tablespace.
 *
 * Modify the conn_string value below, providing your Net Service
 *   Name if not using your default.
 *
 * The value for file_loc must be the location where all your images
 *   for this example are stored.  It is recommended that your images
 *   remain with all of the other sample scripts for this chapter, 
 *   though it is not required.  The directory path must end in the
 *   appropriate slash ("\" for Windows and "/" for Unix/Linux).
 */

DEF conn_string = lob_user/oracle
DEF username = LOB_USER
DEF default_ts = USERS
DEF temp_ts = TEMP
DEF file_loc = c:\files

-- The following directories are for LOB storage, not the schema.
--  You must already have tablespaces created for your schema, and
--  valid names specified above.

DEF clob_datafile_loc = C:\oracle\product\10.1.0\db_1\orcl\clob_ts01.dbf
DEF blob_datafile_loc = C:\oracle\product\10.1.0\db_1\orcl\blob_ts01.dbf


SET FEEDBACK OFF SERVEROUTPUT ON VERIFY OFF TERMOUT OFF

SPOOL CreateLOBUser.log

DECLARE
   v_count       INTEGER        := 0;
   v_statement   VARCHAR2 (500);
BEGIN

   -- Drop the user if it exists

   SELECT COUNT (1)
     INTO v_count
     FROM dba_users
    WHERE username = UPPER ('&username');

   IF v_count != 0
   THEN
      EXECUTE IMMEDIATE ('DROP USER &username CASCADE');
   END IF;

   v_count := 0;

   -- Drop the directory if it exists

   SELECT COUNT(1)
     INTO v_count
     FROM dba_directories
    WHERE directory_name = 'BOOK_SAMPLES_LOC';

   IF v_count != 0
   THEN
      EXECUTE IMMEDIATE ('DROP DIRECTORY BOOK_SAMPLES_LOC');
   END IF;

   -- Create the lob user

   v_statement :=
         'CREATE USER &username IDENTIFIED BY oracle'
      || ' DEFAULT TABLESPACE &default_ts'
      || ' TEMPORARY TABLESPACE &temp_ts'
      || ' QUOTA UNLIMITED ON &default_ts'
      || ' ACCOUNT UNLOCK';

   EXECUTE IMMEDIATE (v_statement);

   -- Grant permissions
   EXECUTE IMMEDIATE ('GRANT connect, resource TO &username');
   EXECUTE IMMEDIATE ('GRANT execute ON ctx_ddl TO &username');
   EXECUTE IMMEDIATE ('GRANT create ANY directory, drop ANY directory TO &username');

   DBMS_OUTPUT.put_line ('	');
   DBMS_OUTPUT.put_line ('User &username created successfully');
   DBMS_OUTPUT.put_line ('	');

   -- Create tablespace for CLOBs

   v_count := 0;

   SELECT COUNT (1)
     INTO v_count
     FROM dba_tablespaces
    WHERE tablespace_name = 'CLOB_TS';

   IF v_count != 0
   THEN
      EXECUTE IMMEDIATE ('DROP TABLESPACE CLOB_TS INCLUDING CONTENTS');
   END IF;

   v_statement := 'CREATE TABLESPACE CLOB_TS DATAFILE ''&clob_datafile_loc'' '
                  || 'SIZE 5M REUSE '
                  || 'AUTOEXTEND ON NEXT 10M '
                  || 'MAXSIZE 10M DEFAULT STORAGE ('
                  || 'INITIAL 512K NEXT 512K '
                  || 'MINEXTENTS 1 MAXEXTENTS 1024'
                  || 'PCTINCREASE 0 ) ';

   EXECUTE IMMEDIATE (v_statement);

   -- Create tablespace for BLOBs

   v_count := 0;

   SELECT COUNT (1)
     INTO v_count
     FROM dba_tablespaces
    WHERE tablespace_name = 'BLOB_TS';

   IF v_count != 0
   THEN
      EXECUTE IMMEDIATE ('DROP TABLESPACE BLOB_TS INCLUDING CONTENTS');
   END IF;

   v_statement := 'CREATE TABLESPACE BLOB_TS DATAFILE ''&blob_datafile_loc'' '
                  || 'SIZE 5M REUSE '
                  || 'AUTOEXTEND ON NEXT 10M '
                  || 'MAXSIZE 10M DEFAULT STORAGE ('
                  || 'INITIAL 512K NEXT 512K '
                  || 'MINEXTENTS 1 MAXEXTENTS 1024'
                  || 'PCTINCREASE 0 ) ';

   EXECUTE IMMEDIATE (v_statement);


EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (SQLERRM);
      DBMS_OUTPUT.put_line ('	');
END;
/

SET FEEDBACK ON TERMOUT ON

CREATE DIRECTORY book_samples_loc AS '&file_loc';
GRANT READ ON DIRECTORY book_samples_loc TO &username;

PROMPT
PROMPT Connecting to &username to create a maintenance package
PROMPT

CONN &conn_string

CREATE OR REPLACE PACKAGE clean_schema IS

   PROCEDURE tables;
   PROCEDURE objects;
   PROCEDURE procs;
   PROCEDURE ind;
 
END;
/


CREATE OR REPLACE PACKAGE BODY clean_schema AS

PROCEDURE tables
IS
   v_string VARCHAR2(50);
   v_tab_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_tab_error, -942); 
BEGIN
   BEGIN
   v_string := 'DROP TABLE varray_lob';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP TABLE book_samples';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP TABLE long_to_lob';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP TABLE book_samples_nls';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_tab_error
      THEN
      NULL;
   END;

END tables;

PROCEDURE objects
IS
   v_string VARCHAR2(50);
   v_obj_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_obj_error, -4043);
BEGIN
   BEGIN
   v_string := 'DROP TYPE varray_table_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP TYPE varray_lob_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP TYPE varray_lob2_obj';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_obj_error
      THEN
      NULL;
   END;

END objects;

PROCEDURE procs
IS
   v_string VARCHAR2(50);
   v_proc_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_proc_error, -4043);
BEGIN
   BEGIN
   v_string := 'DROP PROCEDURE lobappend';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PROCEDURE clob_compare';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PROCEDURE convert_me';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PROCEDURE check_file';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PROCEDURE check_status';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PROCEDURE close_file';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PROCEDURE close_all_files';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

END procs;

PROCEDURE ind
IS
   v_string VARCHAR2(50);
   v_index_error EXCEPTION;
   v_pref_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_index_error, -1418);
   PRAGMA EXCEPTION_INIT(v_pref_error, -20000);
BEGIN
   BEGIN
   v_string := 'DROP INDEX lob_indx force';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_index_error
      THEN
      NULL;
   END;

   BEGIN
   ctx_ddl.drop_preference ('lob_lexer');   
   EXCEPTION
   WHEN v_pref_error
      THEN
      NULL;
   END;

   BEGIN
   ctx_ddl.drop_preference ('lob_wordlist');   
   EXCEPTION
   WHEN v_pref_error
      THEN
      NULL;
   END;

END ind;

END;
/


SPOOL OFF
