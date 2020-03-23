-- ***************************************************************************
-- File: 8_23.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_23.lis

DECLARE
   lv_current_date     DATE := TRUNC(SYSDATE);
   lv_final_date       DATE;
BEGIN
   stop_watch.start_timer;
   FOR lv_count_num IN 1..10000 LOOP
      lv_final_date := lv_current_date;
   END LOOP;
   stop_watch.stop_timer;
END;
/

SPOOL OFF
