-- ***************************************************************************
-- File: 8_29.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_29.lis

SELECT department_name
INTO   :nbt_department_name
FROM   s_department
WHERE  department_id = :department_id;

SPOOL OFF
