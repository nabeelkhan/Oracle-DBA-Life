-- ***************************************************************************
-- File: 16_3.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_3.lis

DECLARE
   lv_salary_increase NUMBER := .10;
BEGIN
   EXECUTE IMMEDIATE 'UPDATE s_employee SET salary =
   NVL(salary, 0) * (1 + :increase)'
      USING lv_salary_increase;
END;
/

SPOOL OFF
