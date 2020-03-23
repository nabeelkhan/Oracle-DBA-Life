/*
 * objectOverload.sql
 * Chapter 8, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This script demonstrates overloading based on user defined object
 * types.
 */
 
CREATE OR REPLACE TYPE t1 AS OBJECT (
  f NUMBER
);
/
 
CREATE OR REPLACE TYPE t2 AS OBJECT (
  f NUMBER
);
/

CREATE OR REPLACE PACKAGE Overload AS
  PROCEDURE Proc(p_Parameter1 IN t1);
  PROCEDURE Proc(p_Parameter1 IN t2);
END Overload;
/

CREATE OR REPLACE PACKAGE BODY Overload AS
  PROCEDURE Proc(p_Parameter1 IN t1) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Proc(t1): ' || p_Parameter1.f);
  END Proc;
  
  PROCEDURE Proc(p_Parameter1 IN t2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Proc(t2): ' || p_Parameter1.f);
  END Proc;
END Overload;
/

set serveroutput on
DECLARE
  v_Obj1 t1 := t1(1);
  v_OBj2 t2 := t2(2);
BEGIN
  Overload.Proc(v_Obj1);
  Overload.proc(v_Obj2);
END;
/

