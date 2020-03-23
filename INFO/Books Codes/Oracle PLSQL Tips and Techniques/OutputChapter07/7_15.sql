-- ***************************************************************************
-- File: 7_15.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 7_15.lis

SELECT employee_last_name, employee_first_name, department_name
FROM s_department dept, s_employee emp
WHERE  emp.department_id = dept.department_id;

SPOOL OFF
