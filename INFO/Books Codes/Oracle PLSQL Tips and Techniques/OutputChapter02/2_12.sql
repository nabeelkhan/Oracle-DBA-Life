-- ***************************************************************************
-- File: 2_12.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_12.lis

UPDATE s_employee
SET    commission_pct = NVL(commission_pct,0) + 10
WHERE  employee_id = 17;

SPOOL OFF
