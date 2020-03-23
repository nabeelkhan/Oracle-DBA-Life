-- ***************************************************************************
-- File: 6_1.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_1.lis

DECLARE
   lv_format_txt  CONSTANT VARCHAR2(11) := '99999.99';
   lv_test_txt             VARCHAR2(11);
   lv_test_num             NUMBER := 54321;
BEGIN
   lv_test_txt := TO_CHAR(lv_test_num, lv_format_txt);
   DBMS_OUTPUT.PUT_LINE('Test Value: ' || lv_test_txt);
END;
/

SPOOL OFF
