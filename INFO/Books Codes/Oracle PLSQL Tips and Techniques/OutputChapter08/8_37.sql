-- ***************************************************************************
-- File: 8_37.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_37.lis

SELECT sql_text
FROM   v$sqlarea   
WHERE  SUBSTR(UPPER(sql_text), 1, 55) = 
   'SELECT EMPLOYEE_ID,EMPLOYEE_LAST_NAME,EMPLOYEE_FIRST_NA';

SPOOL OFF
