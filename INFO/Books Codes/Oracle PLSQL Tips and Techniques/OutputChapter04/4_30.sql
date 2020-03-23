-- ***************************************************************************
-- File: 4_30.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_30.lis

DECLARE
   CURSOR cur_employee IS
      SELECT employee_id, department_id, NVL(salary,0) salary, ROWID
      FROM   s_employee;
   lv_record_num PLS_INTEGER DEFAULT 0;
BEGIN
   FOR lv_emp_rec IN cur_employee LOOP
      lv_record_num := lv_record_num + 1;
      -- Determining the raise amount based on raise criteria
     IF lv_emp_rec.department_id = 10 OR 
        lv_emp_rec.department_id = 41 THEN
         IF lv_emp_rec.salary > 1000 THEN
            lv_emp_rec.salary := lv_emp_rec.salary * 1.05;
         ELSE
            lv_emp_rec.salary := lv_emp_rec.salary * 1.10;
         END IF;
      ELSIF lv_emp_rec.department_id = 31 THEN
         IF lv_emp_rec.salary > 1400 THEN
            lv_emp_rec.salary := lv_emp_rec.salary * 1.05;
         ELSE
            lv_emp_rec.salary := lv_emp_rec.salary * 1.10;
         END IF;
      ELSIF lv_emp_rec.department_id = 50 THEN
         IF lv_emp_rec.salary > 2000 THEN
            lv_emp_rec.salary := lv_emp_rec.salary * 1.05;
         ELSE
            lv_emp_rec.salary := lv_emp_rec.salary * 1.10;
         END IF;
      END IF;
      UPDATE s_employee
      SET    salary = lv_emp_rec.salary
      WHERE  rowid  = lv_emp_rec.ROWID;
   DBMS_OUTPUT.PUT_LINE(' Employee: '   || lv_emp_rec.employee_id  ||
      ' Department: ' || lv_emp_rec.department_id ||' New Salary: ' ||
      to_char(lv_emp_rec.salary, '$999,999.99'));
   END LOOP;
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Update Process Complete. ' || 
      lv_record_num || ' Records Processed.');
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('Error on Record ' || lv_record_num ||
         ': Update Process Aborted.');
         ROLLBACK;
END;
/

SPOOL OFF
