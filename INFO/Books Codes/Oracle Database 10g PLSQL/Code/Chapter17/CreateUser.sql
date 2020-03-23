/*
 * CreateUser.sql
 * Chapter 17, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This script creates the plsql user for chapter 17
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
   EXECUTE IMMEDIATE ('GRANT create sequence TO &username');
   EXECUTE IMMEDIATE ('GRANT resource TO &username');
   EXECUTE IMMEDIATE ('GRANT select ON sys.v_$parameter TO &username');
   EXECUTE IMMEDIATE ('GRANT select ON v_$session to &username');
   EXECUTE IMMEDIATE ('GRANT select ON dba_objects to &username');
   EXECUTE IMMEDIATE ('GRANT scheduler_admin to &username');
   EXECUTE IMMEDIATE ('GRANT execute on DBMS_JOB to &username');
   EXECUTE IMMEDIATE ('GRANT select on v_$instance to &username');
   EXECUTE IMMEDIATE ('GRANT select on dba_scheduler_jobs to &username');
   EXECUTE IMMEDIATE ('GRANT select on dba_jobs_running to &username');
   EXECUTE IMMEDIATE ('GRANT execute on UTL_SMTP to &username');

   DECLARE
      v_error EXCEPTION;
      PRAGMA EXCEPTION_INIT(v_error,-4042);
   BEGIN
      EXECUTE IMMEDIATE ('GRANT execute on UTL_MAIL to &username');
   EXCEPTION
      WHEN v_error
      THEN
         DBMS_OUTPUT.PUT_LINE('UTL_MAIL is not installed.  Examples involving UTL_MAIL will');
         DBMS_OUTPUT.PUT_LINE('not work in your environment.  If you are using Oracle 10g');
         DBMS_OUTPUT.PUT_LINE('run prvtmail.plb and utlmail.sql scripts ');
         DBMS_OUTPUT.PUT_LINE('from the $ORACLE_HOME/rdbms/admin directory as SYSDBA.');
         DBMS_OUTPUT.PUT_LINE('If you run these scripts, you must either rerun this schema');
         DBMS_OUTPUT.PUT_LINE('creation script, or grant execute on UTL_MAIL to the PLSQL user');
   END;

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

   PROCEDURE tables;
   PROCEDURE procs;
   PROCEDURE jobs;
 
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
   v_string := 'DROP TABLE email_tbl';
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
   v_string := 'DROP PACKAGE email_manager';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PACKAGE BODY email_manager';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PROCEDURE get_job_details';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

   BEGIN
   v_string := 'DROP PROCEDURE get_scheduler_details';
   EXECUTE IMMEDIATE (v_string);
   EXCEPTION
   WHEN v_proc_error
      THEN
      NULL;
   END;

END procs;

PROCEDURE jobs
IS
   v_string VARCHAR2(50);
   v_job_error EXCEPTION;
   PRAGMA EXCEPTION_INIT(v_job_error, -27476);
BEGIN
   BEGIN
      DBMS_SCHEDULER.DROP_JOB('EXAMPLE1');
   EXCEPTION
   WHEN v_job_error
   THEN
      NULL;
   END;

   BEGIN
      DBMS_SCHEDULER.DROP_JOB('EXAMPLE2');
   EXCEPTION
   WHEN v_job_error
   THEN
      NULL;
   END;
END jobs;

END;
/


spool off
