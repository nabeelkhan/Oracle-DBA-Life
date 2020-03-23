-- ***************************************************************************
-- File: 13_17.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_17.lis

COLUMN    name FORMAT a22
COLUMN    line FORMAT 9999
COLUMN    text FORMAT a30 word_wrapped
SELECT    name, type, line, text
FROM      user_errors
ORDER BY  name, type, sequence;

SPOOL OFF
