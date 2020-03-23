-- ***************************************************************************
-- File: 8_10.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_10.lis

CREATE OR REPLACE PROCEDURE update_salary AS
   CURSOR cur_employee IS
      SELECT employee_id, salary, ROWID
      FROM   s_employee_test;
   lv_new_salary_num NUMBER;
   lv_count_num      PLS_INTEGER := 0;
   lv_start_time_num PLS_INTEGER;
   lv_total_time_num NUMBER;
BEGIN
   lv_start_time_num := DBMS_UTILITY.GET_TIME;
   FOR cur_employee_rec IN cur_employee LOOP
      lv_count_num := lv_count_num + 1;
      -- Determination of salary increase
      lv_new_salary_num := cur_employee_rec.salary;
      UPDATE s_employee_test
      SET    salary      = lv_new_salary_num
      WHERE  rowid = cur_employee_rec.ROWID;
   END LOOP;
   lv_total_time_num := (DBMS_UTILITY.GET_TIME -
      lv_start_time_num)/100;
   INSERT INTO process_timing_log
      (program_name, execution_date, records_processed,
       elapsed_time_sec)
   VALUES
      ('UPDATE_SALARY', SYSDATE, lv_count_num,
       lv_total_time_num);
   COMMIT;
END update_salary;
/

SPOOL OFF
