-- ***************************************************************************
-- File: 7_45.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 7_45.lis

CREATE OR REPLACE PROCEDURE select_emp
   (p_emp_id_num NUMBER DEFAULT NULL, 
   p_last_name_txt VARCHAR2 DEFAULT NULL,
   p_first_name_txt VARCHAR2 DEFAULT NULL, 
   p_start_date DATE DEFAULT NULL,
   p_dept_num NUMBER DEFAULT NULL) IS
   CURSOR cur_emp IS   
      SELECT employee_last_name, employee_first_name, salary
      FROM   s_employee_test
      WHERE  employee_id         LIKE p_emp_id_num     || '%'
      AND    employee_last_name  LIKE p_last_name_txt  || '%'
      AND    employee_first_name LIKE p_first_name_txt || '%'
      AND    start_date          LIKE p_start_date     || '%'
      AND    department_id       LIKE p_dept_num       || '%';

   lv_last_name_txt  s_employee.employee_last_name%TYPE;
   lv_first_name_txt s_employee.employee_first_name%TYPE;
   lv_salary_num     s_employee.salary%TYPE;
BEGIN
   OPEN cur_emp;
   FETCH cur_emp INTO lv_last_name_txt, lv_first_name_txt, 
                      lv_salary_num;
   CLOSE cur_emp;
   -- Processing Logic
END;
/

SPOOL OFF
