/*
 * Error.sql
 * Chapter 4, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates error functions SQLERRM and SQLCODE
 */

SET SERVEROUTPUT ON
DECLARE
   v_error VARCHAR2(10);
BEGIN
   SELECT dummy
   INTO v_error
   FROM dual
   WHERE 1=2;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE('SQLERRM: '||SQLERRM);
      DBMS_OUTPUT.PUT_LINE('SQLCODE: '||SQLCODE);
END;
/
