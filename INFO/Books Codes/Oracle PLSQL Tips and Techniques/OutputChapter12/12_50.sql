-- ***************************************************************************
-- File: 12_50.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_50.lis

SELECT name, value, isses_modifiable, issys_modifiable
FROM   v$parameter
WHERE  name = 'utl_file_dir';

SPOOL OFF
