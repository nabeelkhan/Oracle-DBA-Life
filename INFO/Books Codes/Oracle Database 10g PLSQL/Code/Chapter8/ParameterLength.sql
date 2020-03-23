/*
 * ParameterLength.sql
 * Chapter 8, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This script illustrates constraints on formal parameters.
 */
 
-- This definition is illegal and will generate a compile error
CREATE OR REPLACE PROCEDURE ParameterLength (
  p_Parameter1 IN OUT VARCHAR2(10),
  p_Parameter2 IN OUT NUMBER(3,1)) AS
BEGIN
  p_Parameter1 := 'abcdefghijklm'; -- 15 characters in length
  p_Parameter2 := 12.3;
END ParameterLength;
/
show errors

-- This definition, however, is legal.
CREATE OR REPLACE PROCEDURE ParameterLength (
  p_Parameter1 IN OUT VARCHAR2,
  p_Parameter2 IN OUT NUMBER) AS
BEGIN
  p_Parameter1 := 'abcdefghijklmno'; -- 15 characters in length
  p_Parameter2 := 12.3;
END ParameterLength;
/
show errors

-- Calling ParameterLength().  The constraints are taken from
-- the actual parameters.
DECLARE
  v_Variable1 VARCHAR2(40);
  v_Variable2 NUMBER(7,3);
BEGIN
  ParameterLength(v_Variable1, v_Variable2);
END;
/

-- Calling ParameterLength() again.  Since the constraints are
-- taken from the actual parameters, this will raise ORA-6502.
DECLARE
  v_Variable1 VARCHAR2(10);
  v_Variable2 NUMBER(7,3);
BEGIN
  ParameterLength(v_Variable1, v_Variable2);
END;
/

-- This version of ParameterLength() will have p_Parameter2
-- constrained, because of the %TYPE declaration.
CREATE OR REPLACE PROCEDURE ParameterLength (
  p_Parameter1 IN OUT VARCHAR2,
  p_Parameter2 IN OUT books.copyright%TYPE) AS
BEGIN
  p_Parameter2 := 12345;
END ParameterLength;
/
show errors

DECLARE
  v_Variable1 VARCHAR2(1);
  -- Declare v_Variable2 with no constraints
  v_Variable2 NUMBER;
BEGIN
  -- Even though the actual parameter has room for 12345, the
  -- constraint on the formal parameter is taken and we get
  -- ORA-6502 on this procedure call.
  ParameterLength(v_Variable1, v_Variable2);
END;
/


