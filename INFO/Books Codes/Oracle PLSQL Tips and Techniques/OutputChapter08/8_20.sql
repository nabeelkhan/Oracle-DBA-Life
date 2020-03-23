-- ***************************************************************************
-- File: 8_20.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_20.lis

DECLARE
   CURSOR cur_employee IS
      SELECT employee_id, salary
      FROM   s_employee_test;
   lv_new_salary_num NUMBER;
BEGIN
   stop_watch.start_timer;
   FOR cur_employee_rec IN cur_employee LOOP
      -- Determination of salary increase
      lv_new_salary_num := cur_employee_rec.salary;
      UPDATE s_employee_test
      SET    salary      = lv_new_salary_num
      WHERE  employee_id = cur_employee_rec.employee_id;
   END LOOP;
   COMMIT;
   stop_watch.stop_timer;
END;
/

SPOOL OFF
