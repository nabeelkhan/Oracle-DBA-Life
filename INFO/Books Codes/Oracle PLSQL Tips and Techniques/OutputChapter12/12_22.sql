-- ***************************************************************************
-- File: 12_22.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_22.lis

BEGIN
   IF DBMS_SESSION.IS_ROLE_ENABLED('ADMINSTRATOR') THEN
      DBMS_OUTPUT.PUT_LINE('Current Role Administrator');
      -- Process Administrator Logic
   ELSIF DBMS_SESSION.IS_ROLE_ENABLED('MANAGER') THEN
      DBMS_OUTPUT.PUT_LINE('Current Role Manager');
      -- Process Manager Logic
   ELSE
      DBMS_OUTPUT.PUT_LINE('Current Role Operator');
      -- Process Operator Logic
   END IF;
END;
/

SPOOL OFF
