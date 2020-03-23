/*
 * ColObj.sql
 * Chapter 15, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates column objects.
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

CREATE TABLE inventory_tbl (
item_id NUMBER(10) PRIMARY KEY,
num_in_stock NUMBER(10),
reorder_status VARCHAR2(20 CHAR),
price discount_price_obj);

INSERT INTO inventory_tbl
     VALUES (1, 10, 'IN STOCK', discount_price_obj (.1, 75));

commit;

DECLARE
   v_price   discount_price_obj;
BEGIN
-- Update attribute of the price object
   SELECT price
     INTO v_price
     FROM inventory_tbl
    WHERE item_id = 1;

   DBMS_OUTPUT.put_line ('	');
   DBMS_OUTPUT.put_line ('Price BEFORE update: ' || v_price.discount_price);
   v_price.discount_rate := .2;

   UPDATE inventory_tbl
      SET price = v_price;

   DBMS_OUTPUT.put_line ('	');
   DBMS_OUTPUT.put_line ('Price AFTER update: ' || v_price.discount_price);
   ROLLBACK;
END;
/

SELECT i.price.price, i.price.discount_rate
  FROM inventory_tbl i;

SELECT i.price.discount_price ()
  FROM inventory_tbl i;
