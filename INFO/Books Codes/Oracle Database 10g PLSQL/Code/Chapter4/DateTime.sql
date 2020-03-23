/*
 * DateTime.sql
 * Chapter 4, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates a few date functions
 */

SET SERVEROUTPUT ON
DECLARE
   v_sysdate DATE := SYSDATE;
   v_systimestamp TIMESTAMP := SYSTIMESTAMP;
   v_date DATE;
   v_number NUMBER(10);
BEGIN

   -- Print the current date
   DBMS_OUTPUT.PUT_LINE(v_sysdate);

   -- Print the current date and timestamp
   DBMS_OUTPUT.PUT_LINE(v_systimestamp);

   -- Calculate the months between two dates
   v_number := MONTHS_BETWEEN('13-JUN-1973', '23-JAN-1973');
   DBMS_OUTPUT.PUT_LINE(v_number);

END;
/

