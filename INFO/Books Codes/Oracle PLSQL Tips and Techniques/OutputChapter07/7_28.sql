-- ***************************************************************************
-- File: 7_28.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 7_28.lis

-- Adds the new column
ALTER TABLE s_employee_test
   ADD employee_dup_id VARCHAR2(7);
-- Updates the new column with the value of the employee_id column
UPDATE s_employee_test
SET    employee_dup_id = employee_id;
-- Creates an index on the new column
CREATE UNIQUE INDEX s_employee_test_idx2 
   ON s_employee_test(employee_dup_id);

SPOOL OFF
