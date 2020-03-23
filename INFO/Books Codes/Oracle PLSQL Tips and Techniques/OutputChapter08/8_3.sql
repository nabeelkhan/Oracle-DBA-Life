-- ***************************************************************************
-- File: 8_3.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_3.lis

DECLARE
   CURSOR cur_employee IS
      SELECT employee_id, salary, ROWID
      FROM   s_employee_test;
   lv_new_salary_num NUMBER;
   lv_count_num      PLS_INTEGER := 0;
   lv_start_time_num PLS_INTEGER;
BEGIN
   lv_start_time_num := DBMS_UTILITY.GET_TIME;
   FOR cur_employee_rec IN cur_employee LOOP
      lv_count_num := lv_count_num + 1;
      -- Determination of salary increase
      lv_new_salary_num := cur_employee_rec.salary;
      UPDATE s_employee_test
      SET    salary      = lv_new_salary_num
      WHERE  rowid = cur_employee_rec.ROWID;
      IF MOD(lv_count_num, 1000) = 0 THEN
         DBMS_APPLICATION_INFO.SET_MODULE('Records Processed: ' ||
           lv_count_num, 'Elapsed: ' || (DBMS_UTILITY.GET_TIME -
           lv_start_time_num)/100 || ' sec');
      END IF;
   END LOOP;
   COMMIT;
      DBMS_APPLICATION_INFO.SET_MODULE('Records Processed: ' ||
         lv_count_num, 'Elapsed: ' || (DBMS_UTILITY.GET_TIME -
         lv_start_time_num)/100 || ' sec');
END;
/

SPOOL OFF
