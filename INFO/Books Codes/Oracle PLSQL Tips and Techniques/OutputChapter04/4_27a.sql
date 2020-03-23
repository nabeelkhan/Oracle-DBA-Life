-- ***************************************************************************
-- File: 4_27a.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_27a.lis

CREATE OR REPLACE PACKAGE BODY name_pkg IS
----------------------------------------------------------------
FUNCTION open_name (p_table_txt IN VARCHAR2, p_id_num IN NUMBER)
   RETURN type_name_refcur IS
   lv_table_txt  VARCHAR2(100) := UPPER(p_table_txt);
   lv_name_rec   type_name_refcur;
BEGIN
   IF lv_table_txt = 'EMPLOYEE' THEN
      OPEN lv_name_rec FOR 
         SELECT employee_last_name || ', '|| employee_first_name
         FROM   s_employee
         WHERE  employee_id = p_id_num;
   ELSIF lv_table_txt = 'CUSTOMER' THEN
      OPEN lv_name_rec FOR 
         SELECT customer_name
         FROM   s_customer
         WHERE  customer_id = p_id_num;
   ELSIF lv_table_txt = 'PRODUCT' THEN
      OPEN lv_name_rec FOR 
         SELECT product_name
         FROM   s_product
         WHERE  product_id = p_id_num;
   ELSE
      RAISE_APPLICATION_ERROR (-20222, 
         'Invalid table specified for name request.');
   END IF;
   RETURN lv_name_rec;
END open_name;
----------------------------------------------------------------
FUNCTION get_name (p_table_txt IN VARCHAR2, p_id_num IN NUMBER)
   RETURN VARCHAR2 IS
   lv_name_rec    type_name_rec;
   lv_name_refcur type_name_refcur;
BEGIN
   -- Call function to return opened cursor variable
   lv_name_refcur := open_name(p_table_txt, p_id_num);
   -- Fetch data for given id from specified table
   FETCH lv_name_refcur INTO lv_name_rec;
   -- Check if data was found
   IF (lv_name_refcur%NOTFOUND) THEN
      CLOSE lv_name_refcur;
      RAISE NO_DATA_FOUND;
   ELSE
      CLOSE lv_name_refcur;
   END IF;
   RETURN lv_name_rec.name;
END get_name;
----------------------------------------------------------------
END name_pkg;
/

SPOOL OFF
