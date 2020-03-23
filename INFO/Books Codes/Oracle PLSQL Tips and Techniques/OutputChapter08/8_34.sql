-- ***************************************************************************
-- File: 8_34.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_34.lis

DECLARE
   CURSOR cur_employee IS
      SELECT *
      FROM   s_employee_test;
   lv_department_txt s_department.department_name%TYPE;
BEGIN
   FOR cur_employee_rec IN cur_employee LOOP
      -- Processing Logic
      SELECT department_name
      INTO   lv_department_txt
      FROM   s_department
      WHERE  department_id = cur_employee_rec.department_id;
      -- Processing Logic
   END LOOP;
END;
/

SPOOL OFF
