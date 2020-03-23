/*
 * forwardDeclarations.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates mutually exclusive subprograms.
 */

set serveroutput on

DECLARE
  v_TempVal BINARY_INTEGER := 5;

  -- Local procedure A. Note that the code of A calls procedure B.
  PROCEDURE A(p_Counter IN OUT BINARY_INTEGER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('A(' || p_Counter || ')');
    IF p_Counter > 0 THEN
      B(p_Counter);
      p_Counter := p_Counter - 1;
    END IF;
  END A;

  -- Local procedure B. Note that the code of B calls procedure A.
  PROCEDURE B(p_Counter IN OUT BINARY_INTEGER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('B(' || p_Counter || ')');
    p_Counter := p_Counter - 1;
    A(p_Counter);
  END B;
BEGIN
  B(v_TempVal);
END;
/

-- We can fix this with a forward declaration for procedure B.
DECLARE
  v_TempVal BINARY_INTEGER := 5;

  -- Forward declaration of procedure B.
  PROCEDURE B(p_Counter IN OUT BINARY_INTEGER);

  PROCEDURE A(p_Counter IN OUT BINARY_INTEGER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('A(' || p_Counter || ')');
    IF p_Counter > 0 THEN
      B(p_Counter);
      p_Counter := p_Counter - 1;
    END IF;
  END A;

  PROCEDURE B(p_Counter IN OUT BINARY_INTEGER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('B(' || p_Counter || ')');
    p_Counter := p_Counter - 1;
    A(p_Counter);
  END B;
BEGIN
  B(v_TempVal);
END;
/
