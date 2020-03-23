-- ***************************************************************************
-- File: 6_29.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_29.lis

DECLARE
   lv_counter_num        PLS_INTEGER := 0;
   lv_timer_start_num    NUMBER;
   lv_timer_previous_num NUMBER;
   lv_timer_current_num  NUMBER;
BEGIN
   lv_timer_start_num    := DBMS_UTILITY.GET_TIME;
   lv_timer_previous_num := lv_timer_start_num;
   DBMS_OUTPUT.PUT_LINE
      ('Timing Per Thousand Records Processed (in secs)');
   LOOP
      lv_counter_num := lv_counter_num + 1;
      IF MOD(lv_counter_num, 1000) = 0 THEN
         lv_timer_current_num := DBMS_UTILITY.GET_TIME;
         DBMS_OUTPUT.PUT_LINE('Time Elapsed-Total: ' ||
            (lv_timer_current_num - lv_timer_start_num)/100 ||
            CHR(9) || ' This Set: ' ||
            (lv_timer_current_num - lv_timer_previous_num)/100 ||
            CHR(9) || ' Records Processed: ' ||
            lv_counter_num);
         lv_timer_previous_num := lv_timer_current_num;
       END IF;
       EXIT WHEN lv_counter_num = 5540;
   END LOOP;
   lv_timer_current_num := DBMS_UTILITY.GET_TIME;
   DBMS_OUTPUT.PUT_LINE('Time Elapsed-Total: ' ||
      (lv_timer_current_num - lv_timer_start_num)/100 ||
       CHR(9) || ' This Set: ' ||
       (lv_timer_current_num - lv_timer_previous_num)/100 ||
        CHR(9) || ' Records Processed: ' ||
        lv_counter_num);
END;
/

SPOOL OFF
