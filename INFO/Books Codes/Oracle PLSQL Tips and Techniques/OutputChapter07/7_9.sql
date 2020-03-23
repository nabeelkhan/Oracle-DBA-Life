-- ***************************************************************************
-- File: 7_9.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 7_9.lis

SELECT disk_reads reads, executions exe, 
       ROUND(disk_reads/DECODE(executions, 0, 1, executions)) ratio,
       command_type type, sql_text text
FROM   v$sqlarea
WHERE  disk_reads > &disk_read_threshold
ORDER BY disk_reads/DECODE(executions, 0, 1, executions) DESC;

SPOOL OFF
