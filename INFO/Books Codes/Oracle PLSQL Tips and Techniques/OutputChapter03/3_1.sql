-- ***************************************************************************
-- File: 3_1.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 3_1.lis

DECLARE
   CURSOR cur_orders IS
      SELECT order_id, customer_id, total
      FROM   s_order;
BEGIN
   FOR lv_order_rec IN cur_orders LOOP
      DBMS_OUTPUT.PUT_LINE('Order Id: ' ||
         TO_CHAR(lv_order_rec.order_id) || ' Customer Id: ' ||
         TO_CHAR(lv_order_rec.customer_id) || ' Total: ' ||
         TO_CHAR(lv_order_rec.total));
   END LOOP;
END;
/

SPOOL OFF
