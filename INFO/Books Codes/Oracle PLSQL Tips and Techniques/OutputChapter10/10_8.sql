-- ***************************************************************************
-- File: 10_8.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 10_8.lis

CREATE OR REPLACE PROCEDURE adjust_salary 
   (p_percent_increase_num NUMBER) AS
   lv_percent_input_num NUMBER;
BEGIN
   lv_percent_input_num := p_percent_increase_num;
   DBMS_OUTPUT.PUT_LINE('Salaries Increased by: ' || 
      p_percent_increase_num);
   lv_percent_input_num := 1 + lv_percent_input_num/100;
   DBMS_OUTPUT.PUT_LINE('Multiplier: ' || lv_percent_input_num);
   UPDATE s_employee
   SET    salary = NVL(salary,0) * lv_percent_input_num;
   COMMIT;
END;
/

SPOOL OFF
