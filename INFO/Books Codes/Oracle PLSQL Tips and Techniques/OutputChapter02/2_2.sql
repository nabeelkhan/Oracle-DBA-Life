-- ***************************************************************************
-- File: 2_2.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 2_2.lis

SET SERVEROUTPUT ON
DECLARE
   CURSOR cur_customers is
      SELECT customer_name, preferred_customer
      FROM   s_customer
      ORDER BY preferred_customer, customer_name;
   lv_customer_txt  s_customer.customer_name%TYPE;
   lv_preferred_txt VARCHAR2(3);
BEGIN
   OPEN cur_customers;
   DBMS_OUTPUT.PUT_LINE('Customer(Preferred)');
   DBMS_OUTPUT.PUT_LINE('-------------------------------');
   LOOP
      FETCH cur_customers INTO lv_customer_txt, lv_preferred_txt;
      IF lv_preferred_txt = 'N' THEN
         lv_preferred_txt := 'NO';
      ELSE
         lv_preferred_txt := 'YES';
      END IF;
      DBMS_OUTPUT.PUT_LINE(lv_customer_txt || '(' || 
         lv_preferred_txt || ')');
      EXIT WHEN cur_customers%NOTFOUND;
   END LOOP;
   CLOSE cur_customers;
END;
/

SPOOL OFF
