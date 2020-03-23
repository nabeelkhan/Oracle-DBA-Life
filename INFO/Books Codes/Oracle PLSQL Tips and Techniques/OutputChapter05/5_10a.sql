-- ***************************************************************************
-- File: 5_10a.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_10a.lis

CREATE OR REPLACE PACKAGE BODY process_emps IS
------------------------------------------------------------------
PROCEDURE populate_emp_table IS
   CURSOR cur_employee IS
      SELECT * 
      FROM   s_employee;
BEGIN
   -- First, empty current PL/SQL table
   lv_emp_tab.DELETE;
   FOR cur_employee_rec IN cur_employee LOOP
      lv_emp_tab(cur_employee_rec.employee_id) :=
         cur_employee_rec.employee_last_name;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
         'Error in procedure POPULATE_EMP_TABLE.', FALSE);
END populate_emp_table;
------------------------------------------------------------------
PROCEDURE check_emp(p_emp_id_num s_employee.employee_id%TYPE) IS
BEGIN
   -- Check existence of an employee, given the employee id
   IF lv_emp_tab.EXISTS(p_emp_id_num) THEN
      DBMS_OUTPUT.PUT_LINE('Employee ID:' || p_emp_id_num || 
         ' is valid for '|| lv_emp_tab(p_emp_id_num) || '.');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Employee ID:' || p_emp_id_num || 
         ' is not found.');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,
         'Error in procedure CHECK_EMPLOYEE.', FALSE);
END check_emp;
------------------------------------------------------------
-- Package Initialization Section
BEGIN 
   -- Call procedure to populate employee PL/SQL table
   populate_emp_table;
END process_emps;
/

SPOOL OFF
