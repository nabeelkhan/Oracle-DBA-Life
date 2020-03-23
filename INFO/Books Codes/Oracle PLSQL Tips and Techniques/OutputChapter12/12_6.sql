-- ***************************************************************************
-- File: 12_6.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_6.lis

SET SERVEROUTPUT ON SIZE 1000000
DECLARE
   lv_module_txt VARCHAR2(48);
   lv_action_txt VARCHAR2(32);
BEGIN
   -- Read Original Values and Display
   DBMS_APPLICATION_INFO.READ_MODULE(lv_module_txt, lv_action_txt);
   DBMS_OUTPUT.PUT_LINE('Before  Module: ' || lv_module_txt ||
      CHR(9) || ' Action: ' || lv_action_txt);
   DBMS_APPLICATION_INFO.SET_MODULE('PL/SQL BLock',
      'Testing DBMS_APPLICATION_INFO');
   -- Read Changed Values and Display
   DBMS_APPLICATION_INFO.READ_MODULE(lv_module_txt, lv_action_txt);
   DBMS_OUTPUT.PUT_LINE('After   Module: ' || lv_module_txt ||
      CHR(9) || ' Action: ' || lv_action_txt);
END;
/

SPOOL OFF
