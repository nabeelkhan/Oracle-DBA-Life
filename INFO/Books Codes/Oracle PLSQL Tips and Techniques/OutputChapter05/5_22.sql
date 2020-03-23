-- ***************************************************************************
-- File: 5_22.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_22.lis

CREATE OR REPLACE FUNCTION customer_csz 
   (p_cust_id_num s_customer.customer_id%TYPE)
   RETURN VARCHAR2 IS 
   CURSOR cur_customer IS
      SELECT RTRIM(city || ', '|| state) || 
             RTRIM(' ' || zip_code) ||
             RTRIM(' ' || country)
      FROM   s_customer
      WHERE  customer_id = p_cust_id_num;
   lv_citystatezip_txt VARCHAR2(75);
BEGIN
   -- Fetch the already formatted string for the customer
   OPEN cur_customer;
   FETCH cur_customer INTO lv_citystatezip_txt;
   CLOSE cur_customer;
   RETURN lv_citystatezip_txt;
END;
/

SPOOL OFF
