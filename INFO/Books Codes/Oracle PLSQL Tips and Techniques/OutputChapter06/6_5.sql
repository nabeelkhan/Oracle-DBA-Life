-- ***************************************************************************
-- File: 6_5.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_5.lis

DECLARE
   lv_test_txt VARCHAR2(5) NOT NULL DEFAULT 'HELLO';
BEGIN
   DBMS_OUTPUT.PUT_LINE('Test Value: ' || lv_test_txt);
END;
/

SPOOL OFF
