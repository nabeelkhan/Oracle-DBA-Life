/*
 * packageError.sql
 * Chapter 8, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This package will not compile because the specification and body 
 * do not match.
 */
 
CREATE OR REPLACE PACKAGE PackageA AS
  FUNCTION FunctionA(p_Parameter1 IN NUMBER,
                     p_Parameter2 IN DATE)
    RETURN VARCHAR2;
END PackageA;
/

CREATE OR REPLACE PACKAGE BODY PackageA AS
  FUNCTION FunctionA(p_Parameter1 IN CHAR)
    RETURN VARCHAR2;
END PackageA;
/
show errors
