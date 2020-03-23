-- ***************************************************************************
-- File: 6_13.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_13.lis

DECLARE
   CURSOR cur_employee_salary IS
      SELECT SUM(salary)
      FROM   s_employee
      WHERE  department_id = 44;
   lv_cur_employee_salary cur_employee_salary%ROWTYPE;
BEGIN
   OPEN cur_employee_salary;
   FETCH cur_employee_salary INTO lv_cur_employee_salary;
   IF cur_employee_salary%FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Record Found.');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Record NOT Found.');
   END IF;
   CLOSE cur_employee_salary;
END;
/

SPOOL OFF
