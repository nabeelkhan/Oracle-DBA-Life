/*
 * RaiseError.sql
 * Chapter 8, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This script shows the behavior of exceptions raised within
 * subprograms.
 */
 
/* Illustrates the behavior of unhandled exceptions and
 * OUT variables. If p_Raise is TRUE, then an unhandled
 * error is raised. If p_Raise is FALSE, the procedure
 * completes successfully.
 */
CREATE OR REPLACE PROCEDURE RaiseError (
  p_Raise IN BOOLEAN,
  p_ParameterA OUT NUMBER) AS
BEGIN
  p_ParameterA := 7;

  IF p_Raise THEN
    /* Even though we have assigned 7 to p_ParameterA, this
     * unhandled exception causes control to return immediately
     * without returning 7 to the actual parameter associated
     * with p_ParameterA.
     */
    RAISE DUP_VAL_ON_INDEX;
  ELSE
    -- Simply return with no error. This will return 7 to the
    -- actual parameter.
    RETURN;
  END IF;
END RaiseError;
/

set serveroutput on

-- This block demonstrates the behavior of OUT variables and
-- raised exceptions.
DECLARE
  v_Num NUMBER := 1;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Value before first call: ' || v_Num);
  RaiseError(FALSE, v_Num);
  DBMS_OUTPUT.PUT_LINE('Value after successful call: ' || v_Num);
  DBMS_OUTPUT.PUT_LINE('');
  
  v_Num := 2;
  DBMS_OUTPUT.PUT_LINE('Value before second call: ' || v_Num);
  RaiseError(TRUE, v_Num);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Value after unsuccessful call: ' || v_Num);
END;
/
