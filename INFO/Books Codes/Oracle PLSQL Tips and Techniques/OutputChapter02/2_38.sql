-- ***************************************************************************
-- File: 2_38.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_38.lis

SELECT 'Line 1' || CHR(10) || 'Line 2' ||
       CHR(9) || 'Line 2-1' || CHR(9) ||
       'Line 2-2' || CHR(10) || 'Line 3' threelines
FROM   DUAL;

SPOOL OFF
