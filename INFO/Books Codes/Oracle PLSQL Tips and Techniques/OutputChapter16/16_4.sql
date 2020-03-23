-- ***************************************************************************
-- File: 16_4.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_4.lis

DECLARE
   TYPE lv_emp_tab IS TABLE OF PLS_INTEGER
      INDEX BY BINARY_INTEGER;
   lv_emp_tab_rec lv_emp_tab;
   lv_count_num   PLS_INTEGER := 0;
   -- Only department 41 is given raises
   CURSOR cur_emps IS
      SELECT employee_id, department_id, salary
      FROM   s_employee
      WHERE  department_id = 41;
BEGIN
   FOR cur_emps_rec IN cur_emps LOOP
      -- Processing Employee Logic
      lv_count_num := lv_count_num + 1;
      lv_emp_tab_rec(lv_count_num) := cur_emps_rec.employee_id;
   END LOOP;
   FORALL lv_bulk_num IN 1..lv_emp_tab_rec.COUNT
      UPDATE s_employee 
      SET salary = NVL(salary, 0) * 1.10
      WHERE employee_id = lv_emp_tab_rec(lv_bulk_num);
END;
/

SPOOL OFF
