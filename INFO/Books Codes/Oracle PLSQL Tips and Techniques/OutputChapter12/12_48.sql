-- ***************************************************************************
-- File: 12_48.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_48.lis

CREATE OR REPLACE PACKAGE errors AS
   pu_failure_excep EXCEPTION;
   PRAGMA EXCEPTION_INIT (pu_failure_excep, -20000);
END errors;
/
CREATE OR REPLACE PROCEDURE error_test1 AS
BEGIN
   RAISE VALUE_ERROR;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_CALL_STACK);
      DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
      RAISE errors.pu_failure_excep;
END error_test1;
/
CREATE OR REPLACE PROCEDURE error_test2 AS
BEGIN
   error_test1;
EXCEPTION
   WHEN errors.pu_failure_excep THEN
      DBMS_OUTPUT.PUT_LINE('Procedure error_test2 Failed.');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_CALL_STACK);
      DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
      DBMS_OUTPUT.PUT_LINE('Procedure error_test2 Failed.');
END error_test2;
/

SPOOL OFF
