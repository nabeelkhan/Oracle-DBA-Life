-- ***************************************************************************
-- File: 8_27.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_27.lis

BEGIN
   stop_watch.start_timer;
   FOR lv_count_num IN 1..10000 LOOP
      IF MOD(lv_count_num, 1000) = 0 THEN
         DBMS_OUTPUT.PUT_LINE('Hit 1000; Total: ' || lv_count_num);
      END IF;
   END LOOP;
   stop_watch.stop_timer;
END;
/

SPOOL OFF
