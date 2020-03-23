-- ***************************************************************************
-- File: 5_34.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_34.lis

CREATE OR REPLACE TRIGGER bi_order_stmt
BEFORE INSERT
ON s_order
BEGIN
   -- Loop through the PL/SQL, performing processing for each order
   FOR lv_tab_index_num IN 1..order_insert.pv_tab_index_num LOOP
      -- Insert initial item record for every item
      INSERT INTO s_item 
      (order_id, item_id, product_id)
      VALUES 
      (order_insert.pv_order_tab_rec(lv_tab_index_num), 1, 232);
   END LOOP;
   -- Initialize package variable counter for subsequent inserts
   order_insert.pv_tab_index_num := 0;
END bi_order_stmt;
/

SPOOL OFF
