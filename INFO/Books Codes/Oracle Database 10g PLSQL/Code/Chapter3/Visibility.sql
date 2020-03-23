/*
 * Visibility.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates variable visibility
 */

exec clean_schema.trigs
exec clean_schema.procs
exec clean_schema.tables

SET SERVEROUTPUT ON

DECLARE
   v_visible VARCHAR2(30);
   v_hidden VARCHAR2(30);
BEGIN
   v_visible := 'v_visible in the outer block';
   v_hidden := 'v_hidden in the outer block';

   DBMS_OUTPUT.PUT_LINE('*** OUTER BLOCK ***');
   DBMS_OUTPUT.PUT_LINE(v_visible);
   DBMS_OUTPUT.PUT_LINE(v_hidden);
   DBMS_OUTPUT.PUT_LINE('	');

   DECLARE
      v_hidden NUMBER(10);
   BEGIN
      DBMS_OUTPUT.PUT_LINE('*** INNER BLOCK ***');
      v_hidden := 'v_hidden in the inner block';
      DBMS_OUTPUT.PUT_LINE(v_hidden);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE('v_hidden of type VARCHAR2 was...hidden');
   END;
END;
/

<<l_outer_block>>
DECLARE
   v_visible VARCHAR2(30);
   v_hidden VARCHAR2(30);
BEGIN
   v_visible := 'v_visible in the outer block';
   v_hidden := 'v_hidden in the outer block';

   DBMS_OUTPUT.PUT_LINE('*** OUTER BLOCK ***');
   DBMS_OUTPUT.PUT_LINE(v_visible);
   DBMS_OUTPUT.PUT_LINE(v_hidden);
   DBMS_OUTPUT.PUT_LINE('	');

   DECLARE
      v_hidden NUMBER(10);
   BEGIN
      DBMS_OUTPUT.PUT_LINE('*** INNER BLOCK ***');
      l_outer_block.v_hidden := 'v_hidden in the inner block';
      DBMS_OUTPUT.PUT_LINE(l_outer_block.v_hidden);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE('v_hidden of type VARCHAR2 was...hidden');
   END;
END;
/