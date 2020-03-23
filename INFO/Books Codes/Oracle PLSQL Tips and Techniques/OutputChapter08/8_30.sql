-- ***************************************************************************
-- File: 8_30.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_30.lis

DECLARE
   CURSOR cur_department IS
      SELECT department_name
      FROM   s_department
      WHERE  department_id = :department_id;
BEGIN
   OPEN cur_department;
   FETCH cur_department INTO :nbt_department_name;
   CLOSE cur_department;
END;

SPOOL OFF
