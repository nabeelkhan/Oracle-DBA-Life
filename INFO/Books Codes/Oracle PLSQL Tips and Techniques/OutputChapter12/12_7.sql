-- ***************************************************************************
-- File: 12_7.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_7.lis

DECLARE
   lv_client_info_txt VARCHAR2(64);
BEGIN
   -- Read Original Value
   DBMS_APPLICATION_INFO.READ_CLIENT_INFO(lv_client_info_txt);
   DBMS_OUTPUT.PUT_LINE('Before  Client Info: ' ||
      NVL(lv_client_info_txt, 'NULL'));
   DBMS_APPLICATION_INFO.SET_CLIENT_INFO
      ('Testing DBMS_APPLICATION_INFO');
   -- Read Changed Value
   DBMS_APPLICATION_INFO.READ_CLIENT_INFO(lv_client_info_txt);
   DBMS_OUTPUT.PUT_LINE('After   Client Info: ' ||
      NVL(lv_client_info_txt, 'NULL'));
END;
/

SPOOL OFF
