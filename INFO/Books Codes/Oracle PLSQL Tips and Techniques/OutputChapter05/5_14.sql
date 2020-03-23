-- ***************************************************************************
-- File: 5_14.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_14.lis

CREATE OR REPLACE PROCEDURE call_test_proc IS
BEGIN
   test_pack.test_proc1;
END;
/

SPOOL OFF
