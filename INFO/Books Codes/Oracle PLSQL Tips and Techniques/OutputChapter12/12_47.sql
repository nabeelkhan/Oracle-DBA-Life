-- ***************************************************************************
-- File: 12_47.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_47.lis

CREATE OR REPLACE PROCEDURE error_test1 AS
BEGIN
   RAISE VALUE_ERROR;
END error_test1;
/
CREATE OR REPLACE PROCEDURE error_test2 AS
BEGIN
   error_test1;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_CALL_STACK);
      DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
END error_test2;
/

SPOOL OFF
