-- ***************************************************************************
-- File: 2_43.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_43.lis

SELECT TRANSLATE('555-143-3344', '1234567890','XXXXXXXXXX') phone
FROM   dual;

SPOOL OFF
