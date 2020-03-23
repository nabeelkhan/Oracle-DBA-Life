-- ***************************************************************************
-- File: 5_8.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_8.lis

DECLARE
   lv_region_name_txt        s_region.region_name%TYPE;
   lv_employee_last_name_txt s_employee.employee_last_name%TYPE;
BEGIN
   BEGIN
      SELECT region_name INTO lv_region_name_txt
      FROM   s_region
      WHERE  region_id = &&region_id;
      DBMS_OUTPUT.PUT_LINE('Region Name: ' || lv_region_name_txt);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Error: Region Select Failed.');
   END;
   BEGIN
      SELECT employee_last_name INTO lv_employee_last_name_txt
      FROM   s_employee
      WHERE  employee_id = &&employee_id;
      DBMS_OUTPUT.PUT_LINE('Emp Last Name: ' || 
         lv_employee_last_name_txt);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Error: Employee Select Failed.');
   END;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 80));
END;
/

SPOOL OFF
