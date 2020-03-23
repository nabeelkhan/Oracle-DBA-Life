-- ***************************************************************************
-- File: 5_33.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_33.lis

CREATE OR REPLACE TRIGGER bi_order_row
BEFORE INSERT
ON s_order
FOR EACH ROW
BEGIN
   -- Increment PL/SQL table index before inserting
   order_insert.pv_tab_index_num := order_insert.pv_tab_index_num + 1;
   -- Add the ORDER_ID to the PL/SQL table
   order_insert.pv_order_tab_rec(order_insert.pv_tab_index_num) :=
      NVL(:OLD.order_id, :NEW.order_id);
END bi_order_row;
/

SPOOL OFF
