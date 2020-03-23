-- ***************************************************************************
-- File: 5_7.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_7.lis

DECLARE
   lv_region_name_txt        s_region.region_name%TYPE;
   lv_employee_last_name_txt s_employee.employee_last_name%TYPE;
BEGIN
   SELECT region_name INTO lv_region_name_txt
   FROM   s_region
   WHERE  region_id = &&region_id;
   SELECT employee_last_name INTO lv_employee_last_name_txt
   FROM   s_employee
   WHERE  employee_id = &&employee_id;
   DBMS_OUTPUT.PUT_LINE('Region Name: ' || lv_region_name_txt);
   DBMS_OUTPUT.PUT_LINE('Emp Last Name: ' || 
      lv_employee_last_name_txt);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Error: One of the Selects Failed.');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 80));
END;
/

SPOOL OFF
