-- ***************************************************************************
-- File: 14_8.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_8.lis

DECLARE
   CURSOR cur_employee IS
      SELECT employee_first_name || ' ' employee_last_name
      FROM   s_employee
      WHERE  employee_id = :sales_rep_id;
   CURSOR cur_region IS
      SELECT region_name
      FROM   s_region
      WHERE  region_id = :region_id;
BEGIN
   OPEN cur_employee;
   FETCH cur_employee INTO :nbt_employee_name;
   CLOSE cur_employee;
   OPEN cur_region;
   FETCH cur_region INTO :nbt_region_name;
   CLOSE cur_region;
END;
/

SPOOL OFF
