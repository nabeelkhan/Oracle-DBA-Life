-- ***************************************************************************
-- File: 5_5.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_5.lis

DECLARE
   lv_count_num PLS_INTEGER := 0;
   -- PL/SQL program unit defined within the PL/SQL program unit and
   PROCEDURE DISPLAY_VALUE (p_value_num PLS_INTEGER) IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE('--------------------------------');
      DBMS_OUTPUT.PUT_LINE('Variable Value: ' || p_value_num);
      DBMS_OUTPUT.PUT_LINE('--------------------------------');
   END;
BEGIN
   display_value(lv_count_num);
   lv_count_num := lv_count_num + 2;
   display_value(lv_count_num);
   lv_count_num := lv_count_num + 4;
   display_value(lv_count_num);
   lv_count_num := lv_count_num + 8;
   display_value(lv_count_num);
END;
/

SPOOL OFF
