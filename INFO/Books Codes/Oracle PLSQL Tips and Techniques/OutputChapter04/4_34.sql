-- ***************************************************************************
-- File: 4_34.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_34.lis

CREATE OR REPLACE PROCEDURE salary_update
    (p_dept_num              s_employee.department_id%TYPE,
     p_update_percentage_num NUMBER,
     p_commit_interval_num   NUMBER := 100) IS

   CURSOR cur_salary (p_department_num s_employee.department_id%TYPE) 
      IS
      SELECT employee_id, NVL(salary,0) salary, rowid
      FROM   s_employee
      WHERE  department_id = p_department_num
      ORDER BY employee_id;
   lv_counter_num   PLS_INTEGER := 0;
   lv_error_code    NUMBER;
   lv_error_message VARCHAR2(150);
BEGIN
   FOR lv_salary_rec IN cur_salary (p_dept_num) LOOP
      -- Increment transaction counter
      lv_counter_num := lv_counter_num + 1;
      -- Update each employee salary with the update_percentage
      UPDATE s_employee
      SET salary = salary * NVL(1 + p_update_percentage_num/100, 1)
      WHERE rowid = lv_salary_rec.ROWID;
      -- Perform commit every commit_interval as passed to procedure
      IF MOD(lv_counter_num, p_commit_interval_num) = 0 THEN
         DBMS_OUTPUT.PUT_LINE('Commit at Record: ' || lv_counter_num);
         COMMIT;
      END IF;
   END LOOP;
   -- Perform commit for any outstanding transactions
   DBMS_OUTPUT.PUT_LINE('Commit at Record: ' || lv_counter_num);
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Process Complete.');
   EXCEPTION
      WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Process Aborted at Record: ' || 
             lv_counter_num);
          ROLLBACK;
          lv_error_code := SQLCODE;
          lv_error_message := SUBSTR(SQLERRM, 1, 150);
          DBMS_OUTPUT.PUT_LINE('Error Code: ' || lv_error_code);
          DBMS_OUTPUT.PUT_LINE('Error Message: ' || lv_error_message);
END salary_update;
/

SPOOL OFF
