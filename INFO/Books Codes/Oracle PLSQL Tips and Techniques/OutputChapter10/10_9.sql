-- ***************************************************************************
-- File: 10_9.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 10_9.lis

CREATE ROLE temp_emp;
GRANT UPDATE ON s_employee TO temp_emp;
GRANT temp_emp TO tempc;

SPOOL OFF
