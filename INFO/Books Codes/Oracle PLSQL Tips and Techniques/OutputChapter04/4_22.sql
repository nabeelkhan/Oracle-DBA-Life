-- ***************************************************************************
-- File: 4_22.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_22.lis

CREATE OR REPLACE PROCEDURE total_customer 
   (p_cust_num s_customer.customer_id%TYPE) IS
   CURSOR cur_customer IS
      SELECT * 
      FROM   s_customer
      WHERE  customer_id = p_cust_num;
   CURSOR cur_orders IS
      SELECT order_id, date_ordered, total
      FROM   s_order
      WHERE  customer_id = p_cust_num
      ORDER BY date_ordered;
   lv_cust_rec s_customer%ROWTYPE;
BEGIN
   -- Fetch customer information, using the customer id parameter.
   OPEN cur_customer;
   FETCH cur_customer INTO lv_cust_rec;
   IF (cur_customer%FOUND) THEN
      -- Output customer name, followed by a blank line
      DBMS_OUTPUT.PUT_LINE('Customer: ' || 
         lv_cust_rec.customer_name || CHR(10));
      -- Loop through all orders, output order information
      FOR lv_ord_rec IN cur_orders LOOP
         DBMS_OUTPUT.PUT_LINE('Order: ' || lv_ord_rec.order_id ||
            '  Date: '  || TO_CHAR(lv_ord_rec.date_ordered, 
            'MM/DD/YYYY') || '  Total: ' || 
            TO_CHAR(lv_ord_rec.total, '$99,999.00'));
      END LOOP;
   ELSE
      -- Output message if customer id passed to procedure was invalid
      DBMS_OUTPUT.PUT_LINE('Customer ID: ' || p_cust_num || 
         ' does not exist.');
   END IF;
   CLOSE cur_customer;
EXCEPTION
   WHEN OTHERS THEN
      Raise_Application_Error(-20100,
      'Error in procedure TOTAL_CUSTOMER.', FALSE);
END total_customer;
/

SPOOL OFF
