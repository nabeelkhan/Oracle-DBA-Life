-- ***************************************************************************
-- File: 7_3.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 7_3.lis

SELECT employee_last_name, employee_first_name, start_date, title
FROM   s_employee
WHERE  title = 'STOCK CLERK'
AND    start_date = '08-MAR-90';

SPOOL OFF
