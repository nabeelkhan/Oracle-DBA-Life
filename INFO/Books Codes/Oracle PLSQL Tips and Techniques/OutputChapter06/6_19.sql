-- ***************************************************************************
-- File: 6_19.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_19.lis

DECLARE
   lv_general_excep EXCEPTION;
BEGIN
   IF '&&input_value' IS NULL THEN
      RAISE lv_general_excep;
   ELSE
      -- Process Logic
      NULL;
   END IF;
EXCEPTION
   WHEN lv_general_excep THEN
      NULL;
END;
/

SPOOL OFF
