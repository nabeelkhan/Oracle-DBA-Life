-- ***************************************************************************
-- File: 12_40.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_40.lis

DECLARE
   lv_return_num  NUMBER;
   lv_value_num_1 NUMBER;
   lv_value_num_2 NUMBER;
BEGIN
   lv_value_num_1 := 100.002;
   lv_value_num_2 := 3.02;
   lv_return_num  := math_calc(TO_CHAR(lv_value_num_1) ||
      ' * ' || TO_CHAR(lv_value_num_2), 5);
   DBMS_OUTPUT.PUT_LINE('Value: ' || lv_return_num);
END;
/

SPOOL OFF
