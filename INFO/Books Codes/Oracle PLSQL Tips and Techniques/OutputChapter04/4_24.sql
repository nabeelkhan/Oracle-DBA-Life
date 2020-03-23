-- ***************************************************************************
-- File: 4_24.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_24.lis

DECLARE
   TYPE type_emp_rec1 IS RECORD
      (emp_last_name_txt  s_employee.employee_last_name%TYPE,
       emp_first_name_txt s_employee.employee_first_name%TYPE);
   TYPE type_emp_rec2 IS RECORD
      (emp_last_name_txt  s_employee.employee_last_name%TYPE,
       emp_first_name_txt s_employee.employee_first_name%TYPE);
   lv_emp_type_rec1   type_emp_rec1;
   lv_emp_type_rec2   type_emp_rec2;
   lv_emp_type_rec3   type_emp_rec2;
BEGIN
   -- Fails with PL/SQL error (PLS-00382: expression is of wrong type)
   lv_emp_type_rec1 := lv_emp_type_rec2;
   -- Executes without error
   lv_emp_type_rec1.emp_last_name_txt := 
      lv_emp_type_rec2.emp_last_name_txt;
   -- Executes without error
   lv_emp_type_rec2 := lv_emp_type_rec3;
END;
/

SPOOL OFF
