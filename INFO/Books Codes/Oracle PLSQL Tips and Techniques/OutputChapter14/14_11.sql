-- ***************************************************************************
-- File: 14_11.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_11.lis

DECLARE
   lv_title_found_bln BOOLEAN := FALSE;
BEGIN
   lv_title_found_bln := validate_title(:title);
   IF NOT lv_title_found_bln THEN
      MESSAGE('Invalid Title. Re-enter a valid Title.');
      RAISE FORM_TRIGGER_FAILURE;
EXCEPTION
   WHEN FORM_TRIGGER_FAILURE THEN
      RAISE;
   WHEN OTHERS THEN
      MESSAGE('Error: UNKNOWN');
      RAISE FORM_TRIGGER_FAILURE;
END;
/

SPOOL OFF
