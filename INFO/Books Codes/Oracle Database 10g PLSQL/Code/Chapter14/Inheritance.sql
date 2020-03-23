/*
 * Inheritance.sql
 * Chapter 14, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates object type inheritance.
 */

exec clean_schema.synonyms
exec clean_schema.tables
exec clean_schema.objects

-- discount_price_obj becomes the datatype of the price
--   attribute in the inventory_obj object type

-- discount_price_obj specification

CREATE OR REPLACE TYPE discount_price_obj AS OBJECT (
   discount_rate   NUMBER (10, 4),
   price           NUMBER (10, 2),
   CONSTRUCTOR FUNCTION discount_price_obj (price NUMBER)
      RETURN SELF AS RESULT
)
INSTANTIABLE FINAL;
/

-- Body

CREATE OR REPLACE TYPE BODY discount_price_obj
AS
   CONSTRUCTOR FUNCTION discount_price_obj (price NUMBER)
      RETURN SELF AS RESULT
   AS
   BEGIN
      SELF.price := price * .9;
      RETURN;
   END discount_price_obj;
END;
/

-- inventory_obj is a complex object type that
--   uses discount_price_obj as a datatype for 
--   the price attribute.  We also create it to
--   be a base object type that can be instantiated.

-- inventory_obj specification

CREATE OR REPLACE TYPE inventory_obj AS OBJECT (
   item_id          NUMBER (10),
   num_in_stock     NUMBER (10),
   reorder_status   VARCHAR2 (20 CHAR),
   price            NUMBER(10,2),
   CONSTRUCTOR FUNCTION inventory_obj (
      item_id        IN   NUMBER,
      num_in_stock   IN   NUMBER,
      price          IN   NUMBER
   )
      RETURN SELF AS RESULT,
   MEMBER PROCEDURE print_inventory,
   MEMBER PROCEDURE print_status,
   MEMBER PROCEDURE print_price
)
INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY inventory_obj
AS
   CONSTRUCTOR FUNCTION inventory_obj (
      item_id        IN   NUMBER,
      num_in_stock   IN   NUMBER,
      price          IN   NUMBER
   )
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.item_id := item_id;
      SELF.num_in_stock := num_in_stock;
      SELF.price := price;
      RETURN;
   END;
   MEMBER PROCEDURE print_inventory
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('INVENTORY FOR BOOKSTORE1');
      DBMS_OUTPUT.put_line ('========================');
      DBMS_OUTPUT.put_line (   'Item number '
                            || SELF.item_id
                            || ' has '
                            || SELF.num_in_stock
                            || ' in stock'
                           );
   END print_inventory;
   MEMBER PROCEDURE print_status
   IS
      v_status   VARCHAR2 (20);
   BEGIN
      IF SELF.num_in_stock > 0
      THEN
         v_status := 'IN STOCK';
      ELSE
         v_status := 'OUT OF STOCK';
      END IF;

      DBMS_OUTPUT.put_line ('INVENTORY STATUS FOR BOOKSTORE1');
      DBMS_OUTPUT.put_line ('===============================');
      DBMS_OUTPUT.put_line ('Item number ' || SELF.item_id || ' is '
                            || v_status
                           );
   END print_status;
   MEMBER PROCEDURE print_price
   IS
      v_discount_price   discount_price_obj
                                           := discount_price_obj (SELF.price);
   BEGIN
      DBMS_OUTPUT.put_line ('BOOKSTORE1 PRICES');
      DBMS_OUTPUT.put_line ('=================');
      DBMS_OUTPUT.put_line ('Item number ' || SELF.item_id);
      DBMS_OUTPUT.put_line ('Retail cost: ' || SELF.price || ' US dollars');
      DBMS_OUTPUT.put_line (   'OUR LOW - LOW - LOW DISCOUNT PRICE: '
                            || v_discount_price.price
                            || ' US dollars'
                           );
   END print_price;
END;
/

-- Use the following to test the inventory_obj object
/******************************************
*
* SET SERVEROUTPUT ON SIZE 1000000
* DECLARE
*    v_inventory   inventory_obj := inventory_obj (3124, 15, 39.99);
* BEGIN
*    v_inventory.print_inventory;
*    DBMS_OUTPUT.put_line ('	');
*    v_inventory.print_status;
*    DBMS_OUTPUT.put_line ('	');
*    v_inventory.print_price;
* END;
* /
* 
*******************************************/


CREATE OR REPLACE TYPE book_obj
UNDER inventory_obj (
   isbn        CHAR (10 CHAR),
   CATEGORY    VARCHAR2 (20 CHAR),
   title       VARCHAR2 (100 CHAR),
   num_pages   NUMBER,
   CONSTRUCTOR FUNCTION book_obj (
      item_id        NUMBER,
      num_in_stock   NUMBER,
      price          NUMBER,
      isbn           CHAR,
      title          VARCHAR2,
      num_pages      NUMBER
   )
      RETURN SELF AS RESULT,
   MEMBER PROCEDURE print_book_information,
   OVERRIDING MEMBER PROCEDURE print_price
)
INSTANTIABLE FINAL;
/

CREATE OR REPLACE TYPE BODY book_obj
IS
   CONSTRUCTOR FUNCTION book_obj (
      item_id        NUMBER,
      num_in_stock   NUMBER,
      price          NUMBER,
      isbn           CHAR,
      title          VARCHAR2,
      num_pages      NUMBER
   )
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.item_id := item_id;
      SELF.num_in_stock := num_in_stock;
      SELF.price := price;
      SELF.isbn := isbn;
      SELF.title := title;
      SELF.num_pages := num_pages;
      RETURN;
   END book_obj;
   MEMBER PROCEDURE print_book_information
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('BOOK INFORMATION');
      DBMS_OUTPUT.put_line ('================');
      DBMS_OUTPUT.put_line ('Title: ' || SELF.title);
      DBMS_OUTPUT.put_line ('# Pages: ' || SELF.num_pages);
      DBMS_OUTPUT.put_line ('# In Stock: ' || SELF.num_in_stock);
   END print_book_information;
   OVERRIDING MEMBER PROCEDURE print_price
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('BOOKSTORE1 PRICES');
      DBMS_OUTPUT.put_line ('================');
      DBMS_OUTPUT.put_line ('Title: ' || SELF.title);
      DBMS_OUTPUT.put_line ('Always low price of: ' || SELF.price);
   END print_price;
END;
/

-- run the following to test book_obj
/******************************************
*
* SET SERVEROUTPUT ON SIZE 1000000
* DECLARE
*    v_book book_obj := book_obj (3124, 15, 39.99, '72121203', 'Oracle DBA 101', 563);
* BEGIN
*    v_book.print_book_information;
*    DBMS_OUTPUT.put_line ('	');
*    v_book.print_price;
* END;
* /
*
*******************************************/
