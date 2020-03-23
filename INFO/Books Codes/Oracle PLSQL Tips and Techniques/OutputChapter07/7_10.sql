-- ***************************************************************************
-- File: 7_10.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 7_10.lis

SELECT buffer_gets gets, executions exe, 
       ROUND(buffer_gets/DECODE(executions, 0, 1, executions)) ratio,
       command_type type, sql_text text
FROM   v$sqlarea
WHERE  buffer_gets > &buffer_gets_threshold
ORDER BY buffer_gets/DECODE(executions, 0, 1, executions) DESC;

SPOOL OFF
