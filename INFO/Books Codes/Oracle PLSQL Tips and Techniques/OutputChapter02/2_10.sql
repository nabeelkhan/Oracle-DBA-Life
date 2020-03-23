-- ***************************************************************************
-- File: 2_10.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_10.lis

SELECT employee_id, employee_last_name last_name, 
       employee_first_name first_name, salary, commission_pct
FROM   s_employee
WHERE  employee_id = 17;

SPOOL OFF
