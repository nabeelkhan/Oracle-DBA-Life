-- ***************************************************************************
-- File: 4_20.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_20.lis

DECLARE
   CURSOR cur_employee IS
      SELECT employee_id,
             employee_last_name || ', ' ||employee_first_name emp_name
      FROM   s_employee
      ORDER BY employee_id;
BEGIN
   FOR lv_cur_employee_rec IN cur_employee LOOP
      DBMS_OUTPUT.PUT_LINE('Employee: ' ||
         TO_CHAR(lv_cur_employee_rec.employee_id) ||
         ' ' || lv_cur_employee_rec.emp_name);
   END LOOP;
   EXCEPTION
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('Error in Employee Procssing.');
END;
/

SPOOL OFF
