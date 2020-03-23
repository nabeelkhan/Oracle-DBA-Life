/*
 * objectView.sql
 * Chapter 15, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates object view creation.
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

-- Creates the inventory_tbl relational table that includes
--  a column object.

CREATE TABLE inventory_tbl (
   item_id          NUMBER (10) PRIMARY KEY,
   num_in_stock     NUMBER (10),
   reorder_status   VARCHAR2 (20 CHAR),
   price            discount_price_obj)
/
-- Recreates the inventory_obj object type to match the
--  inventory_tbl table for use with an object view.

CREATE OR REPLACE TYPE inventory_obj AS OBJECT (
   item_id          NUMBER (10),
   reorder_status   VARCHAR2 (20 CHAR),
   price            discount_price_obj,
   MEMBER PROCEDURE print_inventory,
   MEMBER PROCEDURE print_status,
   MEMBER PROCEDURE print_price
)
INSTANTIABLE NOT FINAL;
/

-- Creates the inventory_vie view

CREATE VIEW inventory_vie
   OF inventory_obj
   WITH OBJECT IDENTIFIER (item_id)
AS
   SELECT i.item_id, i.reorder_status, i.price
     FROM inventory_tbl i
/
INSERT INTO inventory_tbl
     VALUES (1, 10, 'IN STOCK', discount_price_obj (.1, 75));
INSERT INTO inventory_tbl
     VALUES (2, 13, 'IN STOCK', discount_price_obj (.1, 54.95));
INSERT INTO inventory_tbl
     VALUES (3, 24, 'IN STOCK', discount_price_obj (.15, 43.95));
INSERT INTO inventory_tbl
     VALUES (4, 13, 'IN STOCK', discount_price_obj (.1, 60));
INSERT INTO inventory_tbl
     VALUES (5, 5, 'IN STOCK', discount_price_obj (.20, 42.95));
COMMIT ;

PROMPT
PROMPT ** SELECT all records from the inventory_vie object view
PROMPT
SELECT *
  FROM inventory_vie
/
PROMPT
PROMPT ** SELECT columns from the view, attributes from the column object,
PROMPT **  and use the discount_price method.
PROMPT
SELECT i.item_id, i.price.price, i.price.discount_rate,
       i.price.discount_price ()
  FROM inventory_vie i
/
-- The following select will fail against the view even though
--  the column exists in the table.

-- SELECT i.num_in_stock
-- FROM inventory_vie i;

CREATE OR REPLACE TRIGGER inventory_trg
   INSTEAD OF INSERT
   ON inventory_vie
   FOR EACH ROW
BEGIN
   INSERT INTO inventory_tbl
        VALUES (:NEW.item_id, NULL, :NEW.reorder_status, :NEW.price);
END;
/
INSERT INTO inventory_vie
     VALUES (6, 'ON ORDER', discount_price_obj (.15, 64.95));

SELECT *
  FROM inventory_tbl
 WHERE item_id = 6;
