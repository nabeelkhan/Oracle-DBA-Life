-- ***************************************************************************
-- File: 12_1.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 12_1.lis

CREATE OR REPLACE TRIGGER au_inventory
   -- This database trigger executes for each record that the
   -- amount_in_stock falls below the reorder_point and is
   -- performed after the update
   AFTER UPDATE of amount_in_stock
   ON s_inventory
   FOR EACH ROW
   WHEN (new.amount_in_stock < new.reorder_point)
BEGIN
   -- If inventory for a product falls below the reorder point
   -- an alert is sent out and contains the warehouse, product,
   -- amount in stock, and reorder point.
   DBMS_ALERT.SIGNAL('REORDER_THRESHOLD_ALERT', 'Warehouse: ' ||
      :new.warehouse_id || '  Product: ' || :new.product_id ||
      '  Current Stock: ' || :new.amount_in_stock ||
      '  Reorder Point: ' || :new.reorder_point);
END au_inventory;
/

SPOOL OFF
