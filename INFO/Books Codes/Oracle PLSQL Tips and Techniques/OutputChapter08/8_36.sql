-- ***************************************************************************
-- File: 8_36.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_36.lis

SELECT SUBSTR(UPPER(sql_text), 1, 55) sql_text, COUNT(*)
FROM   v$sqlarea   
GROUP BY SUBSTR(UPPER(sql_text), 1, 55)   
HAVING COUNT(*) > 1;   

SPOOL OFF
