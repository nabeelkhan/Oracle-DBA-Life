-- ***************************************************************************
-- File: 12_27.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_27.lis

CREATE OR REPLACE PROCEDURE core_process IS
BEGIN
   IF USER = 'PLSQL_USER' THEN
      DBMS_SESSION.SET_SQL_TRACE(TRUE);
      DBMS_OUTPUT.PUT_LINE('Tracing is turned on...');
   END IF;
   -- Main Logic
   DBMS_SESSION.SET_SQL_TRACE(FALSE);
   DBMS_OUTPUT.PUT_LINE('Tracing is turned off.');
END;
/

SPOOL OFF
