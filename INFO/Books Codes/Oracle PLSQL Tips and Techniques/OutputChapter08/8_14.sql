-- ***************************************************************************
-- File: 8_14.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_14.lis

DECLARE
   CURSOR cur_dept (p_dept_num PLS_INTEGER) IS
      SELECT department_name
      FROM   s_department
      WHERE  department_id = p_dept_num;
   CURSOR cur_employee IS
      SELECT employee_id, department_id, salary
      FROM   s_employee_test;
   lv_dept_name_txt s_department.department_name%TYPE;
BEGIN
   stop_watch.start_timer;
   FOR cur_employee_rec IN cur_employee LOOP
      OPEN cur_dept(cur_employee_rec.department_id);
      FETCH cur_dept INTO lv_dept_name_txt;
      CLOSE cur_dept;
      -- Main Logic
   END LOOP;
   stop_watch.stop_timer;
END;
/

SPOOL OFF
