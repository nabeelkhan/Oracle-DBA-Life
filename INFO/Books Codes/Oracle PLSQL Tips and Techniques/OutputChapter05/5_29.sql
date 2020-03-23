-- ***************************************************************************
-- File: 5_29.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_29.lis

CREATE OR REPLACE TRIGGER ai_order
AFTER INSERT
ON s_order
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
   INSERT INTO s_item 
      (order_id, item_id, product_id)
   VALUES 
      (:NEW.order_id, 1, 232);
END ai_order;
/

SPOOL OFF
