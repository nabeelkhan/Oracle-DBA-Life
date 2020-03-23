-- ***************************************************************************
-- File: 13_9.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_9.lis

COLUMN      table_name FORMAT a20
COLUMN      comments FORMAT a55
SELECT      *
FROM        DICTIONARY
WHERE       table_name LIKE '%DEPEND%';

SPOOL OFF
