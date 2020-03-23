-- ***************************************************************************
-- File: 7_18.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 7_18.lis

EXPLAIN PLAN
SET STATEMENT_ID = 'emp_exist' FOR
SELECT employee_last_name, employee_first_name
FROM   s_employee a
WHERE  EXISTS
(SELECT 'X'
FROM    s_employee_test
WHERE   employee_last_name = a.employee_last_name);

SPOOL OFF
