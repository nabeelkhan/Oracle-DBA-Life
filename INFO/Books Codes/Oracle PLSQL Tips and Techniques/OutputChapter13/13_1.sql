-- ***************************************************************************
-- File: 13_1.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 13_1.lis

SELECT     a.ksppinm, b.ksppstvl
FROM       x$ksppi a, x$ksppcv b
WHERE      a.indx  = b.indx
AND        ksppinm = '_init_sql_file';

SPOOL OFF
