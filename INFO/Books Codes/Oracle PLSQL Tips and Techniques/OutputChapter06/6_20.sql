-- ***************************************************************************
-- File: 6_20.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 6_20.lis

BEGIN
   -- Complex Logic
   UPDATE s_employee
   SET    salary = nvl(salary, 0) * 1.10;
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Update Process Succeeded.');
EXCEPTION
   WHEN OTHERS THEN
      -- Additional Error Processing and Logging
      DBMS_OUTPUT.PUT_LINE('Update Process Failed.');
      ROLLBACK;
END;
/

SPOOL OFF
