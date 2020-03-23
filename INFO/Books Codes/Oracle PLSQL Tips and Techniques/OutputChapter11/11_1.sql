-- ***************************************************************************
-- File: 11_1.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 11_1.lis

DECLARE
  lv_temp_txt VARCHAR2(30) := 'Hello Joe';
BEGIN
   lv_temp_txt := SUBSTR(lv_temp_txt, 1,5);
   DBMS_OUTPUT.PUT_LINE(lv_temp_txt);
END;
/

SPOOL OFF
