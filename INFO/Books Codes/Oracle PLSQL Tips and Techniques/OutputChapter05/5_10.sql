-- ***************************************************************************
-- File: 5_10.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_10.lis

CREATE OR REPLACE PACKAGE process_emps IS
   TYPE emp_table_type IS TABLE OF s_employee.employee_last_name%TYPE
      INDEX BY BINARY_INTEGER;
   lv_emp_tab emp_table_type;
   PROCEDURE populate_emp_table;
   PROCEDURE check_emp(p_emp_id_num s_employee.employee_id%TYPE);
END process_emps;
/

SPOOL OFF
