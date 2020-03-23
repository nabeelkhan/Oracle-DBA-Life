-- ***************************************************************************
-- File: 12_49.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_49.lis

DECLARE
   lv_temp_num        PLS_INTEGER := 0;
   lv_temp_cond_num   PLS_INTEGER := 5;
   lv_timer_start_num PLS_INTEGER;
   lv_timer_end_num   PLS_INTEGER;
BEGIN
   lv_timer_start_num := DBMS_UTILITY.GET_TIME;
   FOR lv_loop_num IN 1..10000 LOOP
      IF lv_temp_cond_num = 1 THEN
         lv_temp_num := lv_temp_num + 1;
      ELSIF lv_temp_cond_num = 2 THEN
         lv_temp_num := lv_temp_num + 1;
      ELSIF lv_temp_cond_num = 3 THEN
         lv_temp_num := lv_temp_num + 1;
      ELSIF lv_temp_cond_num = 4 THEN
         lv_temp_num := lv_temp_num + 1;
      ELSE
         lv_temp_num := lv_temp_num + 1;
      END IF;
   END LOOP;
   lv_timer_end_num := DBMS_UTILITY.GET_TIME;
   DBMS_OUTPUT.PUT_LINE((lv_timer_end_num - lv_timer_start_num)/100);
END;
/

SPOOL OFF
