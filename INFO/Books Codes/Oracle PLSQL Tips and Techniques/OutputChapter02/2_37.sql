-- ***************************************************************************
-- File: 2_37.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_37.lis

SELECT MONTHS_BETWEEN(TO_DATE(TO_CHAR(TO_DATE('&date1'),
       'mmyyyy'), 'mmyyyy'),
       TO_DATE(TO_CHAR(TO_DATE('&date2'), 'mmyyyy'), 
       'mmyyyy')) Diff_Date
FROM   DUAL;

SPOOL OFF
