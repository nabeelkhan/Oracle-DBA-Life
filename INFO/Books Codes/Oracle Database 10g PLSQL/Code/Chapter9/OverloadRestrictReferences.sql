/*
 * OverloadRestrictReferences.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates overloaded packages.
 */

CREATE OR REPLACE PACKAGE Overload AS
  FUNCTION TestFunc(p_Parameter1 IN NUMBER)
    RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES(TestFunc, WNDS, RNDS, WNPS, RNPS);

  FUNCTION TestFunc(p_ParameterA IN VARCHAR2,
                    p_ParameterB IN DATE)
    RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES(TestFunc, WNDS, RNDS, WNPS, RNPS);
END Overload;
/
show errors

CREATE OR REPLACE PACKAGE BODY Overload AS
  FUNCTION TestFunc(p_Parameter1 IN NUMBER)
    RETURN VARCHAR2 IS
  BEGIN
    RETURN 'Version 1';
  END TestFunc;

  FUNCTION TestFunc(p_ParameterA IN VARCHAR2,
                    p_ParameterB IN DATE)
    RETURN VARCHAR2 IS
  BEGIN
    RETURN 'Version 2';
  END TestFunc;
END Overload;
/
show errors

SELECT Overload.TestFunc(1) FROM dual;
SELECT Overload.TestFunc('abc', SYSDATE) FROM dual;
