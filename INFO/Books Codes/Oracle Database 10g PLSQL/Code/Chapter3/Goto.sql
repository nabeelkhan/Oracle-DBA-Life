/*
 * Goto.sql
 * Chapter 3, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates GOTO
 */


PROMPT
PROMPT ** GOTO
PROMPT

SET SERVEROUTPUT ON
BEGIN
   DBMS_OUTPUT.PUT_LINE('BEGINNING OF BLOCK');

   GOTO l_Last_Line;

   DBMS_OUTPUT.PUT_LINE('GOTO didn''t work!');
   RETURN;
   <<l_Last_Line>>
   DBMS_OUTPUT.PUT_LINE('Last Line');
END;
/
