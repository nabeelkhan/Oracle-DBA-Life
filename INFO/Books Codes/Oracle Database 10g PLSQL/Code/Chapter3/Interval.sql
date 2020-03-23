/*
 * Interval.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the use of the INTERVAL types
 */

exec clean_schema.trigs
exec clean_schema.procs
exec clean_schema.tables

SET SERVEROUTPUT ON

PROMPT
PROMPT ** This estimates the time until my daughter leaves for college **
PROMPT

DECLARE
   v_college_deadline TIMESTAMP;
BEGIN
   v_college_deadline := TO_TIMESTAMP('06/06/2004', 'DD/MM/YYYY') 
                         + INTERVAL '12-3' YEAR TO MONTH;

   DBMS_OUTPUT.PUT_LINE('My daughter leaves for college in '
                        ||v_college_deadline);
END;
/



PROMPT
PROMPT ** This gets the date a little more exact **
PROMPT

DECLARE
   v_college_deadline TIMESTAMP;
BEGIN
   v_college_deadline := TO_TIMESTAMP('06/06/2004', 'DD/MM/YYYY') 
                         + INTERVAL '12-3' YEAR TO MONTH
                         + INTERVAL '19 9:0:0.0' DAY TO SECOND;

   DBMS_OUTPUT.PUT_LINE('My daughter leaves for college in '
                        ||v_college_deadline);
END;
/

