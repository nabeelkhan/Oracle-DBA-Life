-- ***************************************************************************
-- File: 2_23.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_23.lis

UPDATE s_employee
SET    start_date = TRUNC(SYSDATE)
WHERE  employee_id < 6;

SPOOL OFF
