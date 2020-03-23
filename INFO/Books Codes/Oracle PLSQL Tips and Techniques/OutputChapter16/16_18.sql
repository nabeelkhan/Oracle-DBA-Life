-- ***************************************************************************
-- File: 16_18.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_18.lis

SELECT ROWID "V8 ROWID",
       DBMS_ROWID.ROWID_TO_RESTRICTED(ROWID,0) "V7 ROWID",
       employee_id, employee_last_name
FROM   s_employee
WHERE  ROWNUM < 3;

SPOOL OFF
