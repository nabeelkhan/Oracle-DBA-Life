-- ***************************************************************************
-- File: 12_2.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_2.lis

SET SERVEROUTPUT ON SIZE 1000000
DECLARE
   lv_message_txt VARCHAR2(1800);
   lv_status_num  PLS_INTEGER;
BEGIN
   -- Registers the alert for the session.
   DBMS_ALERT.REGISTER('REORDER_THRESHOLD_ALERT');
   -- Processes the first 10 alerts and then ends and displays alerts.
   FOR lv_count_num IN 1..10 LOOP
      -- Catches each of the alerts.
      DBMS_ALERT.WAITONE('REORDER_THRESHOLD_ALERT',
         lv_message_txt, lv_status_num);
      -- Status of 0 means successful alert capture, otherwise it is
      -- unsuccessful.
      IF lv_status_num = 0 THEN
         DBMS_OUTPUT.PUT_LINE(lv_message_txt);
      ELSE
         DBMS_OUTPUT.PUT_LINE('Alert Failed.');
      END IF;
   END LOOP;
END;
/

SPOOL OFF
