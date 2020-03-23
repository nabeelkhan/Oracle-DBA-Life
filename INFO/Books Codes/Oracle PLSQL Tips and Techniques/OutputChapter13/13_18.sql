-- ***************************************************************************
-- File: 13_18.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_18.lis

SELECT    DISTINCT name, type 
FROM      all_source
WHERE     UPPER(text) LIKE '%SUBMIT%';

SPOOL OFF
