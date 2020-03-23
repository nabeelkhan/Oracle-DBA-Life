/*
 * overloadedLocal.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates overloaded local procedures.
 */

DECLARE
  -- Two overloaded local procedures
  PROCEDURE LocalProc(p_Parameter1 IN NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('In version 1, p_Parameter1 = ' ||
                         p_Parameter1);
  END LocalProc;

  PROCEDURE LocalProc(p_Parameter1 IN VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('In version 2, p_Parameter1 = ' ||
                         p_Parameter1);
  END LocalProc;
BEGIN
  -- Call version 1
  LocalProc(12345);

  -- And version 2
  LocalProc('abcdef');
END;
/
