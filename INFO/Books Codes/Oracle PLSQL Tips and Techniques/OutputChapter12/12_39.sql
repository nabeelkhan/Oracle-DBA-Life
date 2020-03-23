-- ***************************************************************************
-- File: 12_39.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_39.lis

SET SERVEROUTPUT ON SIZE 1000000
DECLARE
   lv_return_num NUMBER;
BEGIN
   lv_return_num := math_calc('4*5', 2);
   DBMS_OUTPUT.PUT_LINE('Value: ' || lv_return_num);
END;
/

SPOOL OFF
