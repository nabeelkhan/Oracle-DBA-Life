/*
 * NoCopyTest.sql
 * Chapter 8, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This script illustrates the behavior of NOCOPY.
 */
 
-- This procedure demonstrates the syntax of the NOCOPY compiler
-- hint.
CREATE OR REPLACE PROCEDURE NoCopyTest (
  p_InParameter    IN NUMBER,
  p_OutParameter   OUT NOCOPY VARCHAR2,
  p_InOutParameter IN OUT NOCOPY CHAR) IS
BEGIN
  NULL;
END NoCopyTest;
/

-- A modified version of RaiseError, with the out parameter
-- specified as NOCOPY.
CREATE OR REPLACE PROCEDURE RaiseErrorNoCopy (
  p_Raise IN BOOLEAN,
  p_ParameterA OUT NOCOPY NUMBER) AS
BEGIN
  p_ParameterA := 7;
  IF p_Raise THEN
    RAISE DUP_VAL_ON_INDEX;
  ELSE
    RETURN;
  END IF;
END RaiseErrorNoCopy;
/

-- When we call RaiseErrorNoCopy the exception semantics are
-- changed due to NOCOPY.
DECLARE
  v_Num NUMBER := 1;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Value before first call: ' || v_Num);
  RaiseErrorNoCopy(FALSE, v_Num);
  DBMS_OUTPUT.PUT_LINE('Value after successful call: ' || v_Num);
  DBMS_OUTPUT.PUT_LINE('');
  
  v_Num := 2;
  DBMS_OUTPUT.PUT_LINE('Value before second call: ' || v_Num);
  RaiseErrorNoCopy(TRUE, v_Num);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Value after unsuccessful call: ' || v_Num);
END;
/
