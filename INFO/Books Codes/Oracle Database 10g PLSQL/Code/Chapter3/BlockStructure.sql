/*
 * BlockStructure.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the structure of a block
 */

exec clean_schema.trigs
exec clean_schema.procs
exec clean_schema.tables

SET SERVEROUTPUT ON

DECLARE

   v_date_time TIMESTAMP;

BEGIN

   -- Retrieve the timestamp into a variable
   SELECT systimestamp
   INTO v_date_time
   FROM dual;

   -- Display the current time to the screen
   DBMS_OUTPUT.PUT_LINE(v_date_time);

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;
/
