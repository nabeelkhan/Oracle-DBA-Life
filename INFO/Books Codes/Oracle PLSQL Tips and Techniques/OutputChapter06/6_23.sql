-- ***************************************************************************
-- File: 6_23.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_23.lis

DECLARE
   lv_test_date DATE := '01-FEB-99';
BEGIN
   IF  lv_test_date BETWEEN '31-JAN-99' AND '10-FEB-99' THEN
      DBMS_OUTPUT.PUT_LINE('TRUE');
   ELSE
      DBMS_OUTPUT.PUT_LINE('FALSE');
   END IF;
END;
/

SPOOL OFF
