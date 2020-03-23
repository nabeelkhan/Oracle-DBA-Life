-- ***************************************************************************
-- File: 9_16.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_16.lis

SELECT a.username, b.block_gets, b.consistent_gets, 
       b.physical_reads
FROM   v$session a, v$sess_io b
WHERE  a.sid = b.sid
ORDER BY a.username;

SPOOL OFF
