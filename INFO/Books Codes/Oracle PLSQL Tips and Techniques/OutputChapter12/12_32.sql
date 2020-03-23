-- ***************************************************************************
-- File: 12_32.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_32.lis

SELECT sql_text, address, hash_value, 
       sharable_mem, kept_versions
FROM   v$sqlarea
WHERE  kept_versions != 0;

SPOOL OFF
