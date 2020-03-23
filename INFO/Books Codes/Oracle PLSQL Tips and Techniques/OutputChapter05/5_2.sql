-- ***************************************************************************
-- File: 5_2.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_2.lis

BEGIN
   DBMS_OUTPUT.PUT_LINE('Variable Value: ' || 
      global_def.pv_execution_num);
   global_def.pv_execution_num := global_def.pv_execution_num + 1;
   DBMS_OUTPUT.PUT_LINE('Variable Value: ' || 
      global_def.pv_execution_num);
   global_def.pv_execution_num := global_def.pv_execution_num + 1;
   DBMS_OUTPUT.PUT_LINE('Variable Value: ' || 
      global_def.pv_execution_num);
   global_def.pv_execution_num := global_def.pv_execution_num + 1;
   DBMS_OUTPUT.PUT_LINE('Variable Value: ' || 
      global_def.pv_execution_num);
END;
/

SPOOL OFF
