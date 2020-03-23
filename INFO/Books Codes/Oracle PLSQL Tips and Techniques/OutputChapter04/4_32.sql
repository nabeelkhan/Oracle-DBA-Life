-- ***************************************************************************
-- File: 4_32.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_32.lis

-- RB_BIG will be used for the update transaction
COMMIT;
SET TRANSACTION USE ROLLBACK SEGMENT rb_big; 
UPDATE s_employee
SET    salary = NVL(salary, 0) * 1.10;
COMMIT;

SPOOL OFF
