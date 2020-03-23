-- ***************************************************************************
-- File: 6_7.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_7.lis

<<BLOCK1>>
DECLARE
   lv_var_num1 NUMBER := 10;
BEGIN
   <<BLOCK2>>
   DECLARE
      lv_var_num1 NUMBER := 20;
   BEGIN
      DBMS_OUTPUT.PUT_LINE('Value for lv_var_num1:        ' ||
         lv_var_num1);
      DBMS_OUTPUT.PUT_LINE('Value for BLOCK1.lv_var_num1: ' ||
         block1.lv_var_num1);
      DBMS_OUTPUT.PUT_LINE('Value for BLOCK2.lv_var_num1: ' ||
         block2.lv_var_num1);
   END BLOCK2;
END BLOCK1;
/

SPOOL OFF
