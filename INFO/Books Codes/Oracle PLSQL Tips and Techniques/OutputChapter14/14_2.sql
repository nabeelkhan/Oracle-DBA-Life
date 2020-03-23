-- ***************************************************************************
-- File: 14_2.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_2.lis

SELECT employee_first_name,    employee_last_name,
       title
FROM   s_employee;

SELECT employee_first_name, employee_last_name,
       TITLE
FROM   s_employee;

SPOOL OFF
