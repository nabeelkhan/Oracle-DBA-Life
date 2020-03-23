-- ***************************************************************************
-- File: 8_12.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_12.lis

DECLARE
   lv_counter_num       PLS_INTEGER := 0;
   lv_total_counter_num PLS_INTEGER := 0;
BEGIN
   stop_watch.start_timer;
   LOOP
      lv_counter_num       := lv_counter_num + 1;
      lv_total_counter_num := lv_total_counter_num + 1;
      IF lv_counter_num >= 100000 THEN
         DBMS_OUTPUT.PUT_LINE('Processed 100,000 Records. ' ||
            'Total Processed ' || lv_total_counter_num);
         lv_counter_num := 0;
         EXIT WHEN lv_total_counter_num >= 1000000;
      END IF;
   END LOOP;
   stop_watch.stop_timer;
END;
/

SPOOL OFF
