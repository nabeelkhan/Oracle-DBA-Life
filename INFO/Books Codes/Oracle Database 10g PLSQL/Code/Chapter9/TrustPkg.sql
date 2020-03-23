/*
 * TrustPkg.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script builds TrustPkg.sql.
 */

-- Available online as TrustPkg.sql
CREATE OR REPLACE PACKAGE TrustPkg AS
  FUNCTION ToUpper (p_a VARCHAR2) RETURN VARCHAR2 IS  
    LANGUAGE JAVA 
    NAME 'Test.Uppercase(char[]) return char[]';
    PRAGMA RESTRICT_REFERENCES(ToUpper, WNDS, TRUST);  

  PROCEDURE Demo(p_in IN VARCHAR2, p_out OUT VARCHAR2);
  PRAGMA RESTRICT_REFERENCES(Demo, WNDS);
END TrustPkg; 
/
show errors

CREATE OR REPLACE PACKAGE BODY TrustPkg AS
  PROCEDURE Demo(p_in IN VARCHAR2, p_out OUT VARCHAR2) IS
  BEGIN
    p_out := ToUpper(p_in);
  END Demo;
END TrustPkg;
/
show errors
