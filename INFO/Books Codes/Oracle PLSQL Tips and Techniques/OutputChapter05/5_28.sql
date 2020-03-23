-- ***************************************************************************
-- File: 5_28.sql
--
-- Developed By TUSC
--
-- Disclaimer: Neither Osborne/McGraw-Hill, TUSC, nor the author warrant
--             that this source code is error-free. If any errors are
--             found in this source code, please report them to TUSC at
--             (630)960-2909 ext 1011 or trezzoj@tusc.com.
-- ***************************************************************************

SPOOL 5_28.lis

CREATE OR REPLACE TRIGGER bud_item
BEFORE UPDATE OR DELETE
ON s_item
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
   -- If updating, log "OLD" values and mark log_type as 'U'
   IF (UPDATING) THEN
      INSERT INTO s_item_log (ORDER_ID, ITEM_ID, PRODUCT_ID, 
         PRICE, QUANTITY, QUANTITY_SHIPPED, 
         LOG_TYPE, LOG_USER, LOG_DATE )
      VALUES ( :OLD.ORDER_ID, :OLD.ITEM_ID, :OLD.PRODUCT_ID, 
         :OLD.PRICE, :OLD.QUANTITY, :OLD.QUANTITY_SHIPPED, 
         'U', USER, SYSDATE );
   -- If deleting, log "OLD" values and mark log_type as 'D'
   ELSIF (DELETING) THEN
      INSERT INTO s_item_log ( ORDER_ID, ITEM_ID, PRODUCT_ID, 
         PRICE, QUANTITY, QUANTITY_SHIPPED, 
         LOG_TYPE, LOG_USER, LOG_DATE )
      VALUES ( :OLD.ORDER_ID, :OLD.ITEM_ID, :OLD.PRODUCT_ID, 
         :OLD.PRICE, :OLD.QUANTITY, :OLD.QUANTITY_SHIPPED, 
         'D', USER, SYSDATE );
   END IF;
END;
/

SPOOL OFF
