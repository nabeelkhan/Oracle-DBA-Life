-- ***************************************************************************
-- File: 14_3.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_3.lis

DECLARE
   CURSOR cur_employee IS
      SELECT employee_first_name,    employee_last_name,
             title
      FROM   s_employee;
   CURSOR cur_employee_1 IS
      SELECT employee_first_name, employee_last_name,
             TITLE
      FROM   s_employee;
BEGIN
   FOR cur_employee_rec IN cur_employee LOOP
      NULL;
   END LOOP;
   FOR cur_employee_1_rec IN cur_employee_1 LOOP
      NULL;
   END LOOP;
END;
/

SPOOL OFF
