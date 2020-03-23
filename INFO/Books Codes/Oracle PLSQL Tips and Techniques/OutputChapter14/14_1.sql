-- ***************************************************************************
-- File: 14_1.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_1.lis

SELECT sql_text
FROM   v$sqlarea
WHERE  INSTR(UPPER(sql_text), 'EMPLOYEE') > 0;

SPOOL OFF
