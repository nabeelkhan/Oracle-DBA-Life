-- ***************************************************************************
-- File: 8_31.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 8_31.lis

PROCEDURE fill_department(p_department_id_num NUMBER, 
   p_department_name_txt OUT VARCHAR2) IS
   CURSOR cur_department IS
      SELECT department_name
      FROM   s_department
      WHERE  department_id = p_department_id_num;
BEGIN
   OPEN cur_department;
   FETCH cur_department INTO p_department_name_txt;
   CLOSE cur_department;
END;

SPOOL OFF
