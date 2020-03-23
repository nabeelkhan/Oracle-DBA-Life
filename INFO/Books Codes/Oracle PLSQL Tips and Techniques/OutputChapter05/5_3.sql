-- ***************************************************************************
-- File: 5_3.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_3.lis

CREATE OR REPLACE PACKAGE BODY global_def IS
   lv_execution_num PLS_INTEGER := 0;
   PROCEDURE increment_display (p_value_num PLS_INTEGER)IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE('--------------------------------');
      DBMS_OUTPUT.PUT_LINE('Variable Value: ' || p_value_num);
      DBMS_OUTPUT.PUT_LINE('--------------------------------');
   END increment_display;
   PROCEDURE increment_value (p_increment_num PLS_INTEGER) IS
   BEGIN
      lv_execution_num := lv_execution_num + p_increment_num;
      increment_display (lv_execution_num);
   END increment_value;
END global_def;
/

SPOOL OFF
