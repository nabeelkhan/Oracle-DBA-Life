-- ***************************************************************************
-- File: 8_1b.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_1b.lis

CREATE OR REPLACE PACKAGE BODY stop_watch AS
PROCEDURE start_timer AS
BEGIN
   pv_start_time_num     := DBMS_UTILITY.GET_TIME;
   pv_last_stop_time_num := pv_start_time_num;
END start_timer;

PROCEDURE stop_timer AS
BEGIN
   pv_stop_time_num := DBMS_UTILITY.GET_TIME;
   DBMS_OUTPUT.PUT_LINE('Total Time Elapsed: ' ||
      TO_CHAR((pv_stop_time_num - pv_start_time_num)/100,
      '999,999.99') || ' sec   Interval Time: ' ||
      TO_CHAR((pv_stop_time_num - pv_last_stop_time_num)/100,
      '99,999.99') || ' sec');
   pv_last_stop_time_num := pv_stop_time_num;
END stop_timer;
END;
/

SPOOL OFF
