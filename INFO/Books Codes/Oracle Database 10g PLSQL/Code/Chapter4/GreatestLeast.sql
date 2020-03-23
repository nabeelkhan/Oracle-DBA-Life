/*
 * GreatestLeast.sql
 * Chapter 4, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the Greatest and Least functions
 */

SET SERVEROUTPUT ON
DECLARE
   v_char VARCHAR2(10);
   v_number NUMBER(10);
BEGIN

   v_char := GREATEST('A', 'B', 'C');
   v_number := GREATEST(1,2,3);

   DBMS_OUTPUT.PUT_LINE('Greatest Character: '||v_char);
   DBMS_OUTPUT.PUT_LINE('Greatest Number: '||v_number);

   v_char := LEAST('A', 'B', 'C');
   v_number := LEAST(1,2,3);

   DBMS_OUTPUT.PUT_LINE('Least Character: '||v_char);
   DBMS_OUTPUT.PUT_LINE('Least Number: '||v_number);

END;
/

