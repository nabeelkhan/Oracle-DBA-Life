-- ***************************************************************************
-- File: 7_11.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 7_11.lis

SET SERVEROUTPUT ON SIZE 1000000
-- Create the s_employee_test table without records
CREATE TABLE s_employee_test AS
SELECT * FROM s_employee
WHERE  1 = 2;
--Duplicates Employees with unique id and salary modification
DECLARE
   CURSOR cur_employee IS
      SELECT *
      FROM   s_employee
      ORDER BY employee_id;
   lv_total_emps_num PLS_INTEGER:= 0;
BEGIN
   FOR lv_loop_num IN 1..1000 LOOP
      FOR lv_emp_rec IN cur_employee LOOP
         INSERT INTO s_employee_test
            (employee_id, employee_last_name,
            employee_first_name, userid,
            start_date, comments,
            manager_id, title,
            department_id, salary,
            commission_pct)
         VALUES
            (s_employee_id.nextval, lv_emp_rec.employee_last_name,
            lv_emp_rec.employee_first_name, lv_emp_rec.userid,
            lv_emp_rec.start_date, lv_emp_rec.comments,
            lv_emp_rec.manager_id, lv_emp_rec.title,
            lv_emp_rec.department_id, lv_emp_rec.salary + lv_loop_num,
            lv_emp_rec.commission_pct);
         lv_total_emps_num := lv_total_emps_num + 1;
      END LOOP;
      COMMIT;  -- Commits every 25 records
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('Total Employees Inserted: ' || 
      lv_total_emps_num);
END;
/

SPOOL OFF
