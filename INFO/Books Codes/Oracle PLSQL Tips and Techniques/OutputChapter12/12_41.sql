-- ***************************************************************************
-- File: 12_41.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_41.lis

SELECT a.username, a.sid, a.serial#, b.physical_reads,
       b.block_gets, b.consistent_gets
FROM   v$session a, v$sess_io b
WHERE  a.sid = b.sid
AND    NVL(a.username,'XX') NOT IN ('SYS', 'SYSTEM', 'XX')
ORDER BY b.physical_reads DESC;

SPOOL OFF
