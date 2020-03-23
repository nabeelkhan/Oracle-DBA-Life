-- ***************************************************************************
-- File: 6_8.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_8.lis

DECLARE
   lv_counter_num PLS_INTEGER := 0;
BEGIN
   <<LOOP1>>
   LOOP
      <<LOOP2>>
      LOOP
         lv_counter_num := lv_counter_num + 1;
         DBMS_OUTPUT.PUT_LINE('Counter: ' ||
            lv_counter_num);
         EXIT LOOP1 WHEN lv_counter_num = 3;
      END LOOP LOOP2;
         DBMS_OUTPUT.PUT_LINE('Exited LOOP2');
   END LOOP LOOP1;
         DBMS_OUTPUT.PUT_LINE('Exited LOOP1');
END;
/

SPOOL OFF
