-- ***************************************************************************
-- File: 8_24.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_24.lis

CREATE OR REPLACE PROCEDURE test_if (p_condition_num NUMBER) AS
   lv_temp_num         NUMBER := 0;
   lv_temp_cond_num    NUMBER := p_condition_num;
BEGIN
   stop_watch.start_timer;
   FOR lv_count_num IN 1..100000 LOOP
      IF lv_temp_cond_num = '1' THEN
         lv_temp_num := lv_temp_num + 1;
      ELSIF lv_temp_cond_num = '2' THEN
         lv_temp_num := lv_temp_num + 1;
      ELSIF lv_temp_cond_num = '3' THEN
         lv_temp_num := lv_temp_num + 1;
      ELSIF lv_temp_cond_num = '4' THEN
         lv_temp_num := lv_temp_num + 1;
      ELSIF lv_temp_cond_num = '5' THEN
         lv_temp_num := lv_temp_num + 1;
      ELSIF lv_temp_cond_num = '6' THEN
         lv_temp_num := lv_temp_num + 1;
      ELSIF lv_temp_cond_num = '7' THEN
         lv_temp_num := lv_temp_num + 1;
      ELSE
         lv_temp_num := lv_temp_num + 1;
      END IF;
   END LOOP;
   stop_watch.stop_timer;
END;
/

SPOOL OFF
