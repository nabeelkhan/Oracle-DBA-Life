-- ***************************************************************************
-- File: 8_35.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_35.lis

DECLARE
   CURSOR cur_employee IS
      SELECT *
      FROM   s_employee_test;
   CURSOR cur_department
      (p_department_num s_department.department_id%TYPE) IS
      SELECT department_name
      FROM   s_department
      where  department_id = p_department_num;
   lv_department_txt s_department.department_name%TYPE;
BEGIN
   FOR cur_employee_rec IN cur_employee LOOP
      -- Processing Logic
      OPEN cur_department(cur_employee_rec.department_id);
      FETCH cur_department INTO lv_department_txt;
      CLOSE cur_department;
      -- Processing Logic
   END LOOP;
END;
/

SPOOL OFF
