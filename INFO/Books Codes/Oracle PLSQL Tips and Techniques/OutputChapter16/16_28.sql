-- ***************************************************************************
-- File: 16_28.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_28.lis

CREATE INDEX s_employee_idx2 ON s_employee(UPPER(employee_last_name));

SPOOL OFF
