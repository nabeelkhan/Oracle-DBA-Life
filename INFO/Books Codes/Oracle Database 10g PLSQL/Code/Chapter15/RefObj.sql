/*
 * refObj.sql
 * Chapter 15, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates object references using REF.
 */

SET SERVEROUTPUT ON SIZE 1000000

exec clean_schema.synonyms
exec clean_schema.tables
exec clean_schema.objects

CREATE OR REPLACE TYPE discount_price_obj AS OBJECT (
   discount_rate   NUMBER (10, 4),
   price           NUMBER (10, 2),
   MEMBER FUNCTION discount_price
      RETURN NUMBER
)
INSTANTIABLE FINAL;
/

CREATE OR REPLACE TYPE BODY discount_price_obj
AS
   MEMBER FUNCTION discount_price
      RETURN NUMBER
   IS
   BEGIN
      RETURN (SELF.price * (1 - SELF.discount_rate));
   END discount_price;
END;
/


CREATE OR REPLACE TYPE inventory_obj AS OBJECT (
   item_id          NUMBER (10),
   num_in_stock     NUMBER (10),
   reorder_status   VARCHAR2 (20 CHAR),
   price            discount_price_obj,
   MEMBER PROCEDURE print_inventory,
   MEMBER PROCEDURE print_status,
   MEMBER PROCEDURE print_price
)
INSTANTIABLE NOT FINAL;
/

CREATE TABLE inventory_tbl OF inventory_obj
/

INSERT INTO inventory_tbl
            (item_id, num_in_stock, reorder_status, price
            )
     VALUES (1, 10, 'IN STOCK', discount_price_obj (.1, 75)
            );
INSERT INTO inventory_tbl
            (item_id, num_in_stock, reorder_status, price
            )
     VALUES (2, 2, 'ON ORDER', discount_price_obj (.1, 54.95)
            );
INSERT INTO inventory_tbl
            (item_id, num_in_stock, reorder_status, price
            )
     VALUES (3, 24, 'IN STOCK', discount_price_obj (.1, 63.95)
            );
COMMIT ;

DECLARE
   v_inventoryref     REF inventory_obj;
   v_itemid           NUMBER (10);
   v_reorder_status   VARCHAR2 (20 CHAR);
BEGIN
   SELECT REF (i)
     INTO v_inventoryref
     FROM inventory_tbl i
    WHERE reorder_status = 'ON ORDER';

   SELECT i.item_id, i.reorder_status
     INTO v_itemid, v_reorder_status
     FROM inventory_tbl i
    WHERE REF (i) = v_inventoryref;

   DBMS_OUTPUT.put_line (   'Item ID '
                         || v_itemid
                         || ' is '
                         || v_reorder_status
                        );
END;
/
