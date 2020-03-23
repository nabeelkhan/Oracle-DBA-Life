-- ***************************************************************************
-- File: 14_15a.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_15a.lis

CREATE OR REPLACE PACKAGE BODY s_employee_pkg AS
PROCEDURE empquery_refcur
   (p_block_data_rec IN OUT type_emp_ref_cur, 
    p_deptno_num IN NUMBER) IS
BEGIN
   OPEN p_block_data_rec FOR
   SELECT e.employee_id, e.employee_last_name, e.employee_first_name,
          e.salary, e.department_id, d.department_name
   FROM   s_employee e, s_department d
   WHERE  e.department_id = NVL(p_deptno_num, e.department_id)
   AND    e.department_id = d.department_id
   ORDER BY e.employee_id;
END empquery_refcur;
PROCEDURE empquery
   (p_deptno_num IN NUMBER, 
    p_block_data_table IN OUT type_emp_table) IS

      lv_array_num NUMBER := 1;
      CURSOR cur_empselect IS
      SELECT e.employee_id, e.employee_last_name,
           e.employee_first_name, e.salary,
           e.department_id, d.department_name
   FROM    s_employee e, s_department d
   WHERE   e.department_id = NVL(p_deptno_num, e.department_id)
   AND     e.department_id = d.department_id
   ORDER BY e.employee_id;
BEGIN
   OPEN cur_empselect;
   LOOP
      FETCH cur_empselect INTO 
         p_block_data_table(lv_array_num).employee_id,
         p_block_data_table(lv_array_num).employee_last_name,
         p_block_data_table(lv_array_num).employee_first_name,
         p_block_data_table(lv_array_num).salary,
         p_block_data_table(lv_array_num).department_id,
         p_block_data_table(lv_array_num).department_name;
      EXIT WHEN cur_empselect%NOTFOUND;
   lv_array_num := lv_array_num + 1;
   END LOOP;
END empquery;
PROCEDURE empinsert(p_block_data_table IN type_emp_table) IS
   lv_count_num   NUMBER;
BEGIN
   lv_count_num := p_block_data_table.COUNT;
   FOR lv_array_num IN 1..lv_count_num LOOP
      INSERT INTO s_employee( employee_id, employee_last_name,
                  employee_first_name, salary, department_id)
      VALUES (p_block_data_table(lv_array_num).employee_id, 
              p_block_data_table(lv_array_num).employee_last_name, 
              p_block_data_table(lv_array_num).employee_first_name, 
              p_block_data_table(lv_array_num).salary,
              p_block_data_table(lv_array_num).department_id);
   END LOOP;
END empinsert;
PROCEDURE empupdate(p_block_data_table IN type_emp_table) IS
   lv_count_num NUMBER;
BEGIN
   lv_count_num := p_block_data_table.COUNT;
   FOR lv_array_num IN 1..lv_count_num LOOP
      UPDATE s_employee
      SET    employee_last_name  = 
                p_block_data_table(lv_array_num).employee_last_name,
             employee_first_name = 
                p_block_data_table(lv_array_num).employee_first_name,
             salary              = 
                p_block_data_table(lv_array_num).salary,
             department_id       = 
                p_block_data_table(lv_array_num).department_id
      WHERE  employee_id         = 
                p_block_data_table(lv_array_num).employee_id;
   END LOOP;
END empupdate;
PROCEDURE empdelete(p_block_data_table IN type_emp_no_table) IS
   lv_count_num NUMBER;
BEGIN
   lv_count_num := p_block_data_table.COUNT;
   FOR lv_array_num IN 1..lv_count_num LOOP
         DELETE FROM s_employee
          WHERE employee_id = 
                p_block_data_table(lv_array_num).employee_id;
      END LOOP;
END empdelete;
PROCEDURE emplock(p_block_data_table IN type_emp_no_table) IS
   lv_count_num NUMBER;
   lv_block_rec type_emp_rec;
BEGIN
   lv_count_num := p_block_data_table.COUNT;
   FOR lv_array_num IN 1..lv_count_num LOOP
      SELECT e.employee_id, e.employee_last_name,
              e.employee_first_name, e.salary,
              e.department_id, d.department_name
      INTO    lv_block_rec
      FROM    s_employee e, s_department d
      WHERE   e.employee_id   = 
              p_block_data_table(lv_array_num).employee_id
      AND     e.department_id = d.department_id
         FOR UPDATE OF e.employee_last_name NOWAIT;
   END LOOP;
END emplock;
END s_employee_pkg;
/

SPOOL OFF
