-- ***************************************************************************
-- File: 9_7.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_7.lis

SELECT indx, ksppinm
FROM   x$ksppi
WHERE  SUBSTR(ksppinm,1,1) = '_';

SPOOL OFF
