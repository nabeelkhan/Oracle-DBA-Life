-- ***************************************************************************
-- File: 7_36.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 7_36.lis

DECLARE
   CURSOR cur_emp_sal IS
      SELECT ROWID
      FROM   s_employee_test
      WHERE  salary > 1100;
   lv_counter_num PLS_INTEGER := 0;
BEGIN
   FOR cur_emp_sal_rec IN cur_emp_sal LOOP
      lv_counter_num := lv_counter_num + 1;
      UPDATE s_employee_test
      SET    salary = salary + 10000
      WHERE  ROWID = cur_emp_sal_rec.ROWID;
      IF MOD(lv_counter_num,500) = 0 THEN
         DBMS_APPLICATION_INFO.SET_MODULE(lv_counter_num, NULL);
         COMMIT;
      END IF;
   END LOOP;
   DBMS_APPLICATION_INFO.SET_MODULE(lv_counter_num, NULL);
END;
/

SPOOL OFF
