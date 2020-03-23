-- ***************************************************************************
-- File: 13_20.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_20.lis

COLUMN    text    FORMAT    a78
SELECT    text
FROM      all_source
WHERE     name = UPPER('&name')
AND       type = UPPER('&type')
AND       line BETWEEN &starting_line AND &ending_line;

SPOOL OFF
