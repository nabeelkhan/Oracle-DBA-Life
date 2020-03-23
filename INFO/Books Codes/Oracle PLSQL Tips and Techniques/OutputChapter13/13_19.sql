-- ***************************************************************************
-- File: 13_19.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_19.lis

COLUMN    text    FORMAT    a30 word_wrapped
SELECT    name, type, text
FROM      all_source
WHERE     UPPER(text) LIKE '%FREE BLOCKS%';

SPOOL OFF
