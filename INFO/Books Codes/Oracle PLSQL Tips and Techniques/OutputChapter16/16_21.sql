-- ***************************************************************************
-- File: 16_21.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 16_21.lis

CREATE OR REPLACE PROCEDURE display_customers 
   AUTHID CURRENT_USER IS   -- AUTHID is the only change required
   CURSOR cur_cust IS
      SELECT customer_id, customer_name
      FROM   s_customer;
BEGIN
   FOR cur_cust_rec IN cur_cust LOOP
      DBMS_OUTPUT.PUT_LINE('Customer Id: ' || 
         cur_cust_rec.customer_id || CHR(9) || 
         ' Customer Name: ' || cur_cust_rec.customer_name);
   END LOOP;
END display_customers;
/

SPOOL OFF
