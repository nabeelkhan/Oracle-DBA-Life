-- ***************************************************************************
-- File: 4_12.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_12.lis

SET SERVEROUTPUT ON SIZE 1000000
-- This PL/SQL block passes the SYSDATE as all three variables 
-- into the date_range function. The 3 dates that are compared are
-- displayed to show the functionality of the date_range function.
DECLARE
   lv_date_check_bln BOOLEAN;
BEGIN
   lv_date_check_bln := date_range(SYSDATE, SYSDATE, SYSDATE);
   IF lv_date_check_bln THEN
      DBMS_OUTPUT.PUT_LINE('Date in Range: TRUE');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Date in Range: FALSE');
  END IF;
END;
/

SPOOL OFF
