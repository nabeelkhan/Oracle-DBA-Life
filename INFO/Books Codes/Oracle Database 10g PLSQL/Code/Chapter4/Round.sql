/*
 * Round.sql
 * Chapter 4, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the ROUND function
 */

SET SERVEROUTPUT ON
DECLARE
   v_round NUMBER (10,4) := 12345.6789;
BEGIN

   DBMS_OUTPUT.PUT_LINE('Default: '||ROUND(v_round));
   DBMS_OUTPUT.PUT_LINE('+2: '||ROUND(v_round, 2));
   DBMS_OUTPUT.PUT_LINE('-2: '||ROUND(v_round, -2));

END;
/

