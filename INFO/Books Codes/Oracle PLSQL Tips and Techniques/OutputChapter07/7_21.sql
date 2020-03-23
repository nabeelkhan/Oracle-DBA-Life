-- ***************************************************************************
-- File: 7_21.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 7_21.lis

SELECT employee_last_name, employee_first_name
FROM   s_employee_test
WHERE  employee_id = 76031;

SPOOL OFF
