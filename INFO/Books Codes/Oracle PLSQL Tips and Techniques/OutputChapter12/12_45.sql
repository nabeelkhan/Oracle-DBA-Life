-- ***************************************************************************
-- File: 12_45.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_45.lis

BEGIN
   DBMS_TRANSACTION.USE_ROLLBACK_SEGMENT('RB4');
   UPDATE s_employee
   SET    salary = NVL(salary, 0) * 1.1;
END;
/

SPOOL OFF
