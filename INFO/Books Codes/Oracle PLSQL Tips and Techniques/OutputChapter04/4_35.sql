-- ***************************************************************************
-- File: 4_35.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_35.lis

SET SERVEROUTPUT ON SIZE 1000000
BEGIN
   DBMS_OUTPUT.PUT_LINE('Procedure Starting...');
   FOR lv_counter_num in 1..100000 LOOP
      NULL;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('Procedure Complete.');
END;
/

SPOOL OFF
