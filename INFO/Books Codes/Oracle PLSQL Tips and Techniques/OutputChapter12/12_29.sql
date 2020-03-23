-- ***************************************************************************
-- File: 12_29.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_29.lis

SET SERVEROUTPUT ON SIZE 1000000
BEGIN
   global_main.lv_operation_counter_num :=
      global_main.lv_operation_counter_num + 1;
   DBMS_OUTPUT.PUT_LINE('Global Value: ' ||
      global_main.lv_operation_counter_num);
END;
/

SPOOL OFF
