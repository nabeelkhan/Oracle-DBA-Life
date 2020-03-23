-- ***************************************************************************
-- File: 16_31.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_31.lis

SELECT /*+ NO_INDEX (s_employee s_employee_id_pk) */ 
       employee_first_name, employee_last_name
FROM   s_employee
WHERE  employee_id = 25;

SPOOL OFF
