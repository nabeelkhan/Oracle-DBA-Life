-- ***************************************************************************
-- File: 14_7.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 14_7.lis

BEGIN
   SELECT employee_first_name || ' ' employee_last_name
   INTO   :nbt_employee_name
   FROM   s_employee
   WHERE  employee_id = :sales_rep_id;

   SELECT region_name
   INTO   :nbt_region_name
   FROM   s_region
   WHERE  region_id = :region_id;
END;
/

SPOOL OFF
