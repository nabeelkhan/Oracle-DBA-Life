-- ***************************************************************************
-- File: 8_16.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_16.lis

DECLARE
   TYPE type_dept_table IS TABLE OF s_department%ROWTYPE
     INDEX BY BINARY_INTEGER;
   lv_dept_table type_dept_table;
   CURSOR cur_dept IS
     SELECT department_id, department_name
     FROM   s_department;
   CURSOR cur_employee IS
     SELECT employee_id, department_id, salary
     FROM   s_employee_test;
   lv_dept_name_txt s_department.department_name%TYPE;
BEGIN
   stop_watch.start_timer;
   FOR cur_dept_rec IN cur_dept LOOP
     lv_dept_table(cur_dept_rec.department_id).department_id
        := cur_dept_rec.department_id;
     lv_dept_table(cur_dept_rec.department_id).department_name
        := cur_dept_rec.department_name;
   END LOOP;
   FOR cur_employee_rec IN cur_employee LOOP
     lv_dept_name_txt :=
        lv_dept_table(cur_employee_rec.department_id).department_name;
     -- Main Logic
   END LOOP;
   stop_watch.stop_timer;
END;
/

SPOOL OFF
