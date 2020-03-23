-- ***************************************************************************
-- File: 4_26.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 4_26.lis

CREATE OR REPLACE PROCEDURE order_process
   (p_ordering_num NUMBER) IS
   -- This procedure returns the total from an order number being
   -- passed in.
   CURSOR cur_get_order (p_ord_num s_order.order_id%TYPE) IS
      SELECT *
      FROM   s_order
      WHERE  order_id = p_ord_num;
   lv_order_rec cur_get_order%ROWTYPE;
BEGIN
   OPEN cur_get_order (p_ordering_num);
   FETCH cur_get_order INTO lv_order_rec;
   DBMS_OUTPUT.PUT_LINE('Order Total: ' || 
      TO_CHAR(lv_order_rec.total));
   CLOSE cur_get_order;
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20100, 'Order Problem.', FALSE);
END;
/

SPOOL OFF
