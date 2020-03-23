-- ***************************************************************************
-- File: 6_6.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_6.lis

DECLARE
   lv_customer_name_txt s_customer.customer_name%TYPE;
   lv_temp_txt          VARCHAR2(10) NOT NULL DEFAULT 'Testing';
   lv_temp_txt2         lv_temp_txt%TYPE;
BEGIN
   DBMS_OUTPUT.PUT_LINE('Customer Name: ' ||
      NVL(lv_customer_name_txt, 'N/A'));
   DBMS_OUTPUT.PUT_LINE('Temp Var: ' ||
      NVL(lv_temp_txt, 'N/A'));
   DBMS_OUTPUT.PUT_LINE('Temp Var2: ' ||
      NVL(lv_temp_txt2, 'N/A'));
END;
/

SPOOL OFF
