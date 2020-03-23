-- ***************************************************************************
-- File: 9_15.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 9_15.lis

SELECT SUM(gets), SUM(getmisses),
       (1 - (SUM(getmisses) / (SUM(gets) +
       SUM(getmisses)))) * 100 hitrat
FROM   v$rowcache;

SPOOL OFF
