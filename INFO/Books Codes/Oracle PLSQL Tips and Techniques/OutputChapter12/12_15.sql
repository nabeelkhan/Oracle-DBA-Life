-- ***************************************************************************
-- File: 12_15.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_15.lis

DECLARE
   lv_status_num PLS_INTEGER;
BEGIN
   lv_status_num := DBMS_PIPE.REMOVE_PIPE('TEST 1');
   DBMS_OUTPUT.PUT_LINE('Status: ' || lv_status_num);
END;
/

SPOOL OFF
