/*
 * ObjectTable.sql
 * Chapter 15, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the creation of an object table,
 *  and includes an anonymous block to demonstrate DML operations
 *  against an object table.
 */

exec clean_schema.synonyms
exec clean_schema.tables
exec clean_schema.objects

SET SERVEROUTPUT ON SIZE 1000000

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

CREATE TABLE discount_price_tbl OF discount_price_obj;


DECLARE
   v_discount_rate    discount_price_tbl.discount_rate%TYPE;
   v_original_price   discount_price_tbl.price%TYPE;
   v_discount_price   discount_price_tbl.price%TYPE;
BEGIN
   -- INSERT a new row into the discount_price_tbl table
   INSERT INTO discount_price_tbl
        VALUES (.1, 54.95);

   -- UPDATE the record, changing the discount rate
   UPDATE discount_price_tbl
      SET discount_rate = .15
    WHERE discount_rate = .1;

   -- SELECT and print the values to the screen
   SELECT discount_rate, price, price - (discount_rate * price)
     INTO v_discount_rate, v_original_price, v_discount_price
     FROM discount_price_tbl
     WHERE rownum < 2;

   DBMS_OUTPUT.put_line ('Original Price: ' || v_original_price);
   DBMS_OUTPUT.put_line (   'Discount Rate Applied: '
                         || v_discount_rate * 100
                         || '%'
                        );
   DBMS_OUTPUT.put_line ('Our LOW, LOW price: ' || v_discount_price);

   -- DELETE the row we added
   DELETE FROM discount_price_tbl;
END;
/

INSERT INTO discount_price_tbl
     VALUES (.1, 54.95);
INSERT INTO discount_price_tbl
     VALUES (.1, 39.95);
INSERT INTO discount_price_tbl
     VALUES (.15, 42.95);
INSERT INTO discount_price_tbl
     VALUES (.2, 65.95);
INSERT INTO discount_price_tbl
     VALUES (.1, 52.95);

SELECT d.price "Original Price", d.discount_price () "Our Price"
  FROM discount_price_tbl d;


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

CREATE TABLE inventory_tbl OF inventory_obj;

INSERT INTO inventory_tbl
     VALUES (1, 10, 'IN STOCK', discount_price_obj (.1, 75));
