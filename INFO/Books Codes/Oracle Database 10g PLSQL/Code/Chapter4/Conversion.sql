/*
 * Conversion.sql
 * Chapter 4, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the CONVERSION functions
 */

SET SERVEROUTPUT ON
DECLARE
   v_sysdate DATE := SYSDATE;
   v_date DATE;
   v_char VARCHAR2(20);
BEGIN

   -- Print the current date
   DBMS_OUTPUT.PUT_LINE('Today''s Date: '||v_sysdate);

   -- Print the current date/time as a character string and modifies the format
   v_char := TO_CHAR(v_sysdate, 'DD:MM:YYYY HH24:MI:SS');
   DBMS_OUTPUT.PUT_LINE('Display as CHARACTER DD:MM:YYYY HH24:MI:SS: '||v_char);

   -- Convert the character string back to date format
   v_date := TO_DATE(v_char, 'DD:MM:YYYY HH24:MI:SS');
   DBMS_OUTPUT.PUT_LINE('Convert back to DATE format: '||v_date);

END;
/

