-- ***************************************************************************
-- File: 5_37a.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_37a.lis

CREATE OR REPLACE PACKAGE BODY process_vacations IS

PROCEDURE process_schedules (p_vac_tab IN pv_type_vacation_tab) IS
BEGIN
   FOR lv_loop_counter_num IN 1..p_vac_tab.COUNT LOOP
      NULL; -- Processing logic
   END LOOP;
END process_schedules;
END process_vacations;
/

SPOOL OFF
