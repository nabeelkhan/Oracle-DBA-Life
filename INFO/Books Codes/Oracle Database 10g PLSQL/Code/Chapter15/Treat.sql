/*
 * treat.sql
 * Chapter 15, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the TREAT function.
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
                                       := discount_price_obj (.1, SELF.price);
   BEGIN
      DBMS_OUTPUT.put_line ('BOOKSTORE1 PRICES');
      DBMS_OUTPUT.put_line ('=================');
      DBMS_OUTPUT.put_line ('Item number ' || SELF.item_id);
      DBMS_OUTPUT.put_line ('Retail cost: ' || SELF.price || ' US dollars');
      DBMS_OUTPUT.put_line (   'OUR LOW - LOW - LOW DISCOUNT PRICE: '
                            || v_discount_price.discount_price
                            || ' US dollars'
                           );
   END print_price;
END;
/


-- address_obj is at one end of the chain having no dependencies.

CREATE OR REPLACE TYPE address_obj AS OBJECT (
   address1   VARCHAR2 (30 CHAR),
   address2   VARCHAR2 (30 CHAR),
   city       VARCHAR2 (30 CHAR),
   state      CHAR (2 CHAR)
)
INSTANTIABLE FINAL;
/

-- person_obj is also at the end of the chain

CREATE OR REPLACE TYPE person_obj AS OBJECT (
   first_name   VARCHAR2 (20),
   last_name    VARCHAR2 (20)
)
INSTANTIABLE FINAL;
/

-- contact_obj links to the first two object types, and adds
--   one more attribute

CREATE OR REPLACE TYPE contact_obj AS OBJECT (
   NAME      person_obj,
   address   address_obj,
   phone     NUMBER (10)
)
INSTANTIABLE FINAL;
/

-- Finally, publisher_obj.contact_info is created to use contact_obj
--   for its datatype.

CREATE OR REPLACE TYPE publisher_obj AS OBJECT (
   pub_name       VARCHAR2 (30),
   contact_info   contact_obj,
   MEMBER PROCEDURE show_contact
)
INSTANTIABLE FINAL;
/

CREATE OR REPLACE TYPE book_obj
UNDER inventory_obj (
   isbn        CHAR (10 CHAR),
   CATEGORY    VARCHAR2 (20 CHAR),
   title       VARCHAR2 (100 CHAR),
   num_pages   NUMBER,
   publisher   publisher_obj,
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
INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE music_person_obj AS OBJECT (
   first_name   VARCHAR2 (50 CHAR),
   last_name    VARCHAR2 (50 CHAR)
)
FINAL INSTANTIABLE;
/

CREATE OR REPLACE TYPE music_obj
UNDER inventory_obj (
   style      VARCHAR2 (50 CHAR),
   composer   music_person_obj,
   artist     music_person_obj
)
NOT FINAL INSTANTIABLE;
/

CREATE TABLE inventory_tbl OF inventory_obj;

INSERT INTO inventory_tbl
     VALUES (music_obj (1,
                        10,
                        'IN STOCK',
                        11.99,
                        'Hip-Hop',
                        music_person_obj ('George', 'Instructor'),
                        music_person_obj ('George', 'Instructor')
                       ));
                       
INSERT INTO inventory_tbl
     VALUES (book_obj (2,
                       13,
                       'IN STOCK',
                       54.95,
                       '72121203',
                       'TECHNICAL',
                       'Oracle DBA 101',
                       563,
                       publisher_obj ('Oracle Press',
                                      contact_obj (person_obj ('Susan',
                                                               'Publisher'
                                                              ),
                                                   address_obj ('123 Street',
                                                                'Suite 2',
                                                                'My City',
                                                                'CO'
                                                               ),
                                                   '5555555555'
                                                  )
                                     )
                      ));