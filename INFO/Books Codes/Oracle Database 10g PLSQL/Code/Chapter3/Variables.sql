/*
 * Variables.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates constants
 */

exec clean_schema.trigs
exec clean_schema.procs
exec clean_schema.tables

SET SERVEROUTPUT ON

PROMPT
PROMPT ** The following block declares a variable as a constant
PROMPT **  then attempts to change the assigned value.
PROMPT

DECLARE
   v_first_name CONSTANT VARCHAR2(50) := 'Ron';
BEGIN
   v_first_name := 'Ronald';
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
