-- ***************************************************************************
-- File: 9_6.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_6.lis

SELECT name, value, isdefault, 
       isses_modifiable, issys_modifiable
FROM   v$parameter
ORDER BY name;

SPOOL OFF
