-- ***************************************************************************
-- File: 16_5.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_5.lis

DECLARE
   lv_new_salary_num s_employee.salary%TYPE;
BEGIN
   UPDATE s_employee
   SET    salary = NVL(salary, 0) * 1.2
   WHERE  employee_id = 1
   RETURNING salary INTO lv_new_salary_num;
   DBMS_OUTPUT.PUT_LINE('New Salary: ' ||
      lv_new_salary_num);
END;
/

SPOOL OFF
