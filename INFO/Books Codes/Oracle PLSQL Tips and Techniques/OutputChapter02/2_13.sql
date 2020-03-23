-- ***************************************************************************
-- File: 2_13.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_13.lis

SELECT employee_id, commission_pct
FROM   s_employee
WHERE  commission_pct IS NOT NULL;

SPOOL OFF
