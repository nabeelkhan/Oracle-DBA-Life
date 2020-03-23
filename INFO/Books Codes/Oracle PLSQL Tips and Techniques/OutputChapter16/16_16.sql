-- ***************************************************************************
-- File: 16_16.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_16.lis

DECLARE 
   lv_seed_num   PLS_INTEGER := 123456789;
   lv_random_num PLS_INTEGER;
BEGIN
   DBMS_RANDOM.INITIALIZE(lv_seed_num);
   FOR lv_loop_num IN 1..5 LOOP
      lv_random_num := DBMS_RANDOM.RANDOM;
      DBMS_OUTPUT.PUT_LINE('Loop: ' || lv_loop_num ||
         '   Random Number: ' || lv_random_num);
   END LOOP;
   DBMS_RANDOM.TERMINATE;
END;
/

SPOOL OFF
