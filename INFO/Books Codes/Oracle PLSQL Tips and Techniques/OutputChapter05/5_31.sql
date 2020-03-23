-- ***************************************************************************
-- File: 5_31.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_31.lis

CREATE OR REPLACE TRIGGER bi_item
BEFORE INSERT
ON s_item
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
   CURSOR cur_check_item IS
      SELECT MAX(item_id)
      FROM   s_item
      WHERE  order_id = :NEW.order_id;
   lv_max_item_num NUMBER;
BEGIN
   IF (:NEW.item_id IS NULL) THEN
      OPEN cur_check_item;
      FETCH cur_check_item INTO lv_max_item_num;
      CLOSE cur_check_item;
      :NEW.item_id := NVL(lv_max_item_num, 0) + 1;
   END IF;
END bi_item;
/

SPOOL OFF
