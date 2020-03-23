-- ***************************************************************************
-- File: 6_3.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_3.lis

DECLARE
   lv_current_date      DATE := SYSDATE;
   lv_current_month_txt VARCHAR(3) := TO_CHAR(SYSDATE, 'MON');
BEGIN
   DBMS_OUTPUT.PUT_LINE('Current Date:  ' ||lv_current_date);
   DBMS_OUTPUT.PUT_LINE('Current Month: ' ||lv_current_month_txt);
END;
/

SPOOL OFF
