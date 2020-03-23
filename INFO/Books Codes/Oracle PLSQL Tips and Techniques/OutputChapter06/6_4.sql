-- ***************************************************************************
-- File: 6_4.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_4.lis

DECLARE
   CURSOR cur_employee IS
      SELECT employee_last_name, employee_first_name, employee_id
      FROM   s_employee
      ORDER BY employee_last_name;
   CURSOR cur_customer IS
      SELECT *
      FROM   s_customer;
   -- Multiple variables declared based on cursor with
   -- columns listed (selected columns)
   lv_cur_emp_rec        cur_employee%ROWTYPE;
   -- Multiple variables declared based on cursor without
   -- columns listed (all columns)
   lv_cur_cust_rec       cur_customer%ROWTYPE;
   -- Multiple variables declared based on database 
   -- table (all columns)
   lv_emp_rec            s_employee%ROWTYPE;
   -- One variable declared based on previously declared %ROWTYPE 
   -- variable
   lv_emp_last_name_txt  lv_cur_emp_rec.employee_last_name%TYPE;
   -- One variable declared based on previous variable declaration
   lv_emp_last_name_txt2 lv_emp_last_name_txt%TYPE;
   -- Two variables declared based on database table column 
   -- definitions
   lv_cust_name_txt      s_customer.customer_name%TYPE;
   lv_emp_first_name_txt s_employee.employee_first_name%TYPE;
BEGIN
   lv_cur_emp_rec.employee_last_name := 'TREZZO';
   lv_cur_cust_rec.customer_name     := 'TUSC';
   lv_emp_rec.employee_first_name    := 'JOE';
   lv_emp_last_name_txt              := 'TREZZO';
   lv_emp_last_name_txt2             := 'TREZZO';
   lv_cust_name_txt                  := 'TUSC';
   lv_emp_first_name_txt             := 'JOE';
END;
/

SPOOL OFF
