-- ***************************************************************************
-- File: 6_18.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_18.lis

DECLARE
   lv_test_num1 PLS_INTEGER := 5;
   lv_test_num2 PLS_INTEGER := 10;
   lv_test_num3 PLS_INTEGER := 15;
   lv_test_num4 PLS_INTEGER := 5;
BEGIN
   IF lv_test_num1 = lv_test_num2 THEN
      DBMS_OUTPUT.PUT_LINE('Test 1 and Test 2 Equal');
   ELSIF lv_test_num1 = lv_test_num3 THEN
      DBMS_OUTPUT.PUT_LINE('Test 1 and Test 3 Equal');
   ELSIF lv_test_num1 = lv_test_num4 THEN
      DBMS_OUTPUT.PUT_LINE('Test 1 and Test 4 Equal');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Test 1 Not Equal to Test 2,3 or 4');
   END IF;
END;
/

SPOOL OFF
