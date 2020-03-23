-- ***************************************************************************
-- File: 4_31.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_31.lis

DECLARE
   -- Declared prior to the cursor reference
   lv_prev_rowid ROWID; 
   -- Main query for all employee records
   CURSOR cur_employee IS  
      SELECT employee_id, department_id, NVL(salary,0) salary, ROWID
      FROM   s_employee;
   -- Queries the current employee record to get the most up to date
   -- contents of the record and locks the record
   CURSOR cur_employee_lock IS 
      SELECT employee_id, department_id, NVL(salary,0) salary
      FROM   s_employee
      WHERE  rowid = lv_prev_rowid
      FOR UPDATE NOWAIT;             -- Attempts to lock the record
   lv_record_num number DEFAULT 0;
   lv_failed_num number DEFAULT 0;
   lv_emp_rec       cur_employee_lock%ROWTYPE;
BEGIN
   FOR lv_emp_nolock_rec IN cur_employee LOOP
      lv_record_num := lv_record_num + 1;
      lv_prev_rowid := lv_emp_nolock_rec.rowid;
      BEGIN  -- Must create another block to trap NOWAIT error
         OPEN cur_employee_lock;  -- Requery record-FOR UPDATE NOWAIT
         FETCH cur_employee_lock into lv_emp_rec;
         -- Determining the raise amount based on conditions
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
         WHERE  rowid  = lv_emp_nolock_rec.rowid;
         DBMS_OUTPUT.PUT_LINE(' Employee: '    || 
            lv_emp_rec.employee_id   || ' Department: '  || 
            lv_emp_rec.department_id || ' New Salary: '  ||
            to_char(lv_emp_rec.salary, '$999,999.99'));
         CLOSE cur_employee_lock;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('***** Employee Id: ' ||
               lv_emp_nolock_rec.employee_id ||
               ' Not Processed Due to Lock *****');
            lv_failed_num := lv_failed_num + 1;
            ROLLBACK;  -- Rollback any records with errors
            IF cur_employee_lock%ISOPEN THEN
               CLOSE cur_employee_lock;
            END IF;
      END;
   END LOOP;
   lv_record_num := lv_record_num - lv_failed_num;
   DBMS_OUTPUT.PUT_LINE('Update Process Complete. ' || 
      lv_record_num || ' Records Processed.');
   DBMS_OUTPUT.PUT_LINE(lv_failed_num || ' Records Not Processed.');
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('Error on Record ' || lv_record_num ||
         ': Update Process Aborted.');
         ROLLBACK;

SPOOL OFF
