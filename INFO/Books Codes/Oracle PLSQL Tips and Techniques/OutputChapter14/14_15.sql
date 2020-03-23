-- ***************************************************************************
-- File: 14_15.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_15.lis

CREATE OR REPLACE PACKAGE s_employee_pkg AS 
   TYPE type_emp_rec IS RECORD
      (employee_id         s_employee.employee_id%TYPE,
       employee_last_name  s_employee.employee_last_name%TYPE,
       employee_first_name s_employee.employee_first_name%TYPE,
       salary              s_employee.salary%TYPE,
       department_id       s_employee.department_id%TYPE,
       department_name     s_department.department_name%TYPE);
   TYPE type_emp_no_rec IS RECORD
      (employee_id         s_employee.employee_id%TYPE);
   TYPE type_emp_ref_cur  IS REF CURSOR RETURN type_emp_rec;
   TYPE type_emp_table    IS TABLE OF type_emp_rec 
                             INDEX BY BINARY_INTEGER;
   TYPE type_emp_no_table IS TABLE OF type_emp_no_rec 
                             INDEX BY BINARY_INTEGER;

   PROCEDURE empquery_refcur 
      (p_block_data_rec IN OUT type_emp_ref_cur, 
       p_deptno_num IN NUMBER); 
   PROCEDURE empquery  
      (p_deptno_num IN NUMBER,
       p_block_data_table IN OUT type_emp_table);
   PROCEDURE empinsert (p_block_data_table IN type_emp_table);
   PROCEDURE empupdate (p_block_data_table IN type_emp_table);
   PROCEDURE empdelete (p_block_data_table IN type_emp_no_table);
   PROCEDURE emplock   (p_block_data_table IN type_emp_no_table);
END s_employee_pkg;
/

SPOOL OFF
