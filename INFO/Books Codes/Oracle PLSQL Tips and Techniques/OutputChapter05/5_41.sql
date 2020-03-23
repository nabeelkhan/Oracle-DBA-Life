-- ***************************************************************************
-- File: 5_41.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_41.lis

DECLARE
   -- Define an exception
   lv_excep EXCEPTION;
BEGIN
   -- Block Processing Logic
   -- Call the exception logic
   RAISE lv_excep;
EXCEPTION
   WHEN lv_excep THEN
      RAISE_APPLICATION_ERROR(-20101, 'Defined exception occurred.');
   WHEN OTHERS THEN
      -- Executed when any error occurs
      RAISE_APPLICATION_ERROR(-20100, 'Unknown exception occurred.');
END;
/

SPOOL OFF
