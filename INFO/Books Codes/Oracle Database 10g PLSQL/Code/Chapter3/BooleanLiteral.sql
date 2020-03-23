/*
 * BooleanLiteral.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates Boolean literals
 */

exec clean_schema.trigs
exec clean_schema.procs
exec clean_schema.tables

SET SERVEROUTPUT ON

PROMPT
PROMPT ** The following example shows how Boolean variables
PROMPT **  can be evaluated.
PROMPT

DECLARE
   v_true BOOLEAN := TRUE;
   v_false BOOLEAN := FALSE;
   v_null BOOLEAN := NULL;
BEGIN
   IF v_true
   THEN
      DBMS_OUTPUT.PUT_LINE('true');
   END IF;

   IF v_false
   THEN 
      DBMS_OUTPUT.PUT_LINE('false');
   END IF;

   IF v_null
   THEN
      DBMS_OUTPUT.PUT_LINE('null');
   END IF;
END;
/
