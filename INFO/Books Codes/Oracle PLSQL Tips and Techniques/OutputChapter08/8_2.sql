-- ***************************************************************************
-- File: 8_2.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_2.lis

BEGIN
   stop_watch.start_timer;
   FOR lv_count_num IN 1..5 LOOP
      DBMS_LOCK.SLEEP(5);
      stop_watch.stop_timer;
   END LOOP;
END;
/

SPOOL OFF
