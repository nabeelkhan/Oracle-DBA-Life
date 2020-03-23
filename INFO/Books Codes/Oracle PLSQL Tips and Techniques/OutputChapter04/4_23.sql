-- ***************************************************************************
-- File: 4_23.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_23.lis

DECLARE
   TYPE type_emp_comp_rec IS RECORD
      (emp_last_name_txt      s_employee.employee_last_name%TYPE,
       emp_first_name_txt     s_employee.employee_first_name%TYPE,
       emp_salary_num         s_employee.salary%TYPE,
       emp_commission_pct_num s_employee.commission_pct%TYPE );
   lv_emp_comp_rec1 type_emp_comp_rec;
   lv_emp_comp_rec2 type_emp_comp_rec;
BEGIN
   lv_emp_comp_rec1.emp_last_name_txt  := 'TREZZO';
   lv_emp_comp_rec2.emp_first_name_txt := 'JOE';
END;
/

SPOOL OFF
