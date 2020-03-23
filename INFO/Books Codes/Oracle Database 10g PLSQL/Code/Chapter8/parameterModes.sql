/*
 * parameterModes.sql
 * Chapter 8, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * These procedures are used to demonstrate the behavior of
 * IN, OUT, and IN OUT parameter modes.
 */

set serveroutput on format wrapped

-- This procedure takes a single IN parameter.
CREATE OR REPLACE PROCEDURE ModeIn (
  p_InParameter IN NUMBER) AS
  
  v_LocalVariable NUMBER := 0;
BEGIN
  DBMS_OUTPUT.PUT('Inside ModeIn: ');
  IF (p_InParameter IS NULL) THEN
    DBMS_OUTPUT.PUT_LINE('p_InParameter is NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('p_InParameter = ' || p_InParameter);
  END IF;

  /* Assign p_InParameter to v_LocalVariable. This is legal,
     since we are reading from an IN parameter and not writing
     to it. */
  v_LocalVariable := p_InParameter;
  
  DBMS_OUTPUT.PUT('At end of ModeIn: ');
  IF (p_InParameter IS NULL) THEN
    DBMS_OUTPUT.PUT_LINE('p_InParameter is NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('p_InParameter = ' || p_InParameter);
  END IF;
END ModeIn;
/
show errors


DECLARE
  v_In NUMBER := 1;
BEGIN
  -- Call ModeIn with a variable, which should remain unchanged.
  DBMS_OUTPUT.PUT_LINE('Before calling ModeIn, v_In = ' || v_In);
  ModeIn(v_In);
  DBMS_OUTPUT.PUT_LINE('After calling ModeIn, v_In = ' || v_In);
END;
/

-- This procedure takes a single OUT parameter.
CREATE OR REPLACE PROCEDURE ModeOut (
  p_OutParameter OUT NUMBER) AS
  
  v_LocalVariable NUMBER := 0;
BEGIN
  DBMS_OUTPUT.PUT('Inside ModeOut: ');
  IF (p_OutParameter IS NULL) THEN
    DBMS_OUTPUT.PUT_LINE('p_OutParameter is NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('p_OutParameter = ' || p_OutParameter);
  END IF;

  /* Assign 7 to p_OutParameter. This is legal, since we
     are writing to an OUT parameter. */
  p_OutParameter := 7;

  /* Assign p_OutParameter to v_LocalVariable. This is also legal, 
   * since we are reading from an OUT parameter. */
  v_LocalVariable := p_OutParameter;
  
  DBMS_OUTPUT.PUT('At end of ModeOut: ');  
  IF (p_OutParameter IS NULL) THEN
    DBMS_OUTPUT.PUT_LINE('p_OutParameter is NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('p_OutParameter = ' || p_OutParameter);
  END IF;
END ModeOut;
/
show errors

DECLARE
  v_Out NUMBER := 1;
BEGIN
  -- Call ModeOut with a variable, which should be modified.
  DBMS_OUTPUT.PUT_LINE('Before calling ModeOut, v_Out = ' || v_Out);
  ModeOut(v_Out);
  DBMS_OUTPUT.PUT_LINE('After calling ModeOut, v_Out = ' || v_Out);
END;
/

-- This procedure takes a single IN OUT parameter.
CREATE OR REPLACE PROCEDURE ModeInOut (
  p_InOutParameter IN OUT NUMBER) IS

  v_LocalVariable  NUMBER := 0;
BEGIN
  DBMS_OUTPUT.PUT('Inside ModeInOut: ');
  IF (p_InOutParameter IS NULL) THEN
    DBMS_OUTPUT.PUT_LINE('p_InOutParameter is NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('p_InOutParameter = ' || p_InOutParameter);
  END IF;

  /* Assign p_InOutParameter to v_LocalVariable. This is legal,
     since we are reading from an IN OUT parameter. */
  v_LocalVariable := p_InOutParameter;

  /* Assign 8 to p_InOutParameter. This is legal, since we
     are writing to an IN OUT parameter. */
  p_InOutParameter := 8;
  
  DBMS_OUTPUT.PUT('At end of ModeInOut: ');
  IF (p_InOutParameter IS NULL) THEN
    DBMS_OUTPUT.PUT_LINE('p_InOutParameter is NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('p_InOutParameter = ' || p_InOutParameter);
  END IF;
END ModeInOut;
/
show errors

DECLARE
  v_InOut NUMBER := 1;
BEGIN
  -- Call ModeInOut with a variable, which should be modified.
  DBMS_OUTPUT.PUT_LINE('Before calling ModeInOut, v_InOut = ' ||
                       v_InOut);
  ModeInOut(v_InOut);
  DBMS_OUTPUT.PUT_LINE('After calling ModeInOut, v_InOut = ' || 
                       v_InOut);
END;
/

BEGIN
  -- We cannot call ModeOut (or ModeInOut) with a constant, since
  -- the actual parameter must identify a storage location.
  ModeOut(3);
END;
/

BEGIN
  -- We can call ModeIn with a constant, though.
  ModeIn(3);
END;
/

-- This procedure will not compile, since it attempts to modify an
-- IN parameter.
CREATE OR REPLACE PROCEDURE IllegalModeIn (
  p_InParameter IN NUMBER) AS
BEGIN
  /* Assign 7 to p_InParameter. This is ILLEGAL, since we
     are writing to an IN parameter. */
  p_InParameter := 7;
END IllegalModeIn;
/
show errors
