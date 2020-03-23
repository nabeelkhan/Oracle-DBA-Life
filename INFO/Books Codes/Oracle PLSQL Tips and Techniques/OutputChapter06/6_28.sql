-- ***************************************************************************
-- File: 6_28.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_28.lis

DECLARE
   lv_test_bln BOOLEAN;
BEGIN
   lv_test_bln := UPPER('&test_var') IN ('TREZZO','BROWN','NIEMIEC');
   IF lv_test_bln THEN
      DBMS_OUTPUT.PUT_LINE('Result: TRUE');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Result: FALSE');
   END IF;
END;
/

SPOOL OFF
