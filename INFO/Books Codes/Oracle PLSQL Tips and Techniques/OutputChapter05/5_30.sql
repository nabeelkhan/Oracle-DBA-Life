-- ***************************************************************************
-- File: 5_30.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_30.lis

CREATE OR REPLACE TRIGGER bud_item
AFTER INSERT OR UPDATE OF price, quantity OR DELETE
ON s_item
FOR EACH ROW
BEGIN
   -- Update the total for the order by deducting the current line 
   -- item total and adding the new line item total.
   UPDATE s_order
   SET total = NVL(total,0) + 
              (NVL(:NEW.price,0) * NVL(:NEW.quantity,0)) - 
              (NVL(:OLD.price,0) * NVL(:OLD.quantity,0))
   WHERE order_id = NVL(:OLD.order_id, :NEW.order_id);
END bud_item;
/

SPOOL OFF
