-- ***************************************************************************
-- File: 14_9.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_9.lis

DECLARE
   pu_failure_excep EXCEPTION;
   PRAGMA EXCEPTION_INIT(pu_failure_excep, -20000);
BEGIN
   validate_title(:title);
EXCEPTION
   WHEN pu_failure_excep THEN 
      MESSAGE('Invalid Title. Re-enter a valid Title.');
      RAISE FORM_TRIGGER_FAILURE;
   WHEN OTHERS THEN
      MESSAGE('Error: UNKNOWN');
      RAISE FORM_TRIGGER_FAILURE;
END;
/

SPOOL OFF
