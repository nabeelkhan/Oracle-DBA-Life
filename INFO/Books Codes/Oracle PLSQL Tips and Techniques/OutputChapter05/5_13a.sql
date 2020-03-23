-- ***************************************************************************
-- File: 5_13a.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_13a.lis

CREATE OR REPLACE PACKAGE BODY test_pack IS
PROCEDURE test_proc1 IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE('Executing test_proc1.');
   END test_proc1;
PROCEDURE test_proc2 IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE('Executing test_proc2.');
   END test_proc2;
END test_pack;
/

SPOOL OFF
