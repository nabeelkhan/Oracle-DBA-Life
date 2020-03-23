-- ***************************************************************************
-- File: 14_6.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_6.lis

DECLARE
   lv_temp_cust_num NUMBER;
BEGIN
   lv_temp_cust_num := pkg_vars.get_pnumber('pkg_vars.pv_cust_num');
   DBMS_OUTPUT.PUT_LINE('Customer Number: ' || lv_temp_cust_num);
END;
/

SPOOL OFF
