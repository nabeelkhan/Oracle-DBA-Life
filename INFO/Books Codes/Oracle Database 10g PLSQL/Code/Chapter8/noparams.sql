/*
 * noparams.sql
 * Chapter 8, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This procedure and function demonstrate the syntax of calling
 * subprograms with no parameters.
 */
 
CREATE OR REPLACE PROCEDURE NoParamsP AS
BEGIN
  DBMS_OUTPUT.PUT_LINE('No Parameters!');
END NoParamsP;
/

CREATE OR REPLACE FUNCTION NoParamsF
  RETURN DATE AS
BEGIN
  RETURN SYSDATE;
END NoParamsF;
/

BEGIN
  NoParamsP;
  DBMS_OUTPUT.PUT_LINE('Calling NoParamsF on ' ||
    TO_CHAR(NoParamsF, 'DD-MON-YYYY'));
END;
/
