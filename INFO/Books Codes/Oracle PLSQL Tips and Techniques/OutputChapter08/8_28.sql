-- ***************************************************************************
-- File: 8_28.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_28.lis

DECLARE
   lv_count_inc_num PLS_INTEGER := 0;
BEGIN
   stop_watch.start_timer;
   FOR lv_count_num IN 1..10000 LOOP
      lv_count_inc_num := lv_count_inc_num + 1;
      IF lv_count_inc_num = 1000 THEN
         DBMS_OUTPUT.PUT_LINE('Hit 1000; Total: ' || lv_count_num);
         lv_count_inc_num := 0;
      END IF;
   END LOOP;
   stop_watch.stop_timer;
END;
/

SPOOL OFF
