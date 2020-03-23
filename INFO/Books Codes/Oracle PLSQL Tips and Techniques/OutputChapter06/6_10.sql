-- ***************************************************************************
-- File: 6_10.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_10.lis

BEGIN
   UPDATE s_employee
   SET    salary = nvl(salary, 0) * 1.10
   WHERE  department_id  = 32;
   DBMS_OUTPUT.PUT_LINE('Number of Rows Updated: ' ||
      SQL%ROWCOUNT);
END;
/

SPOOL OFF
