/*
 * objMaintain.sql
 * Chapter 15, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates type evolution.
 */

SET SERVEROUTPUT ON SIZE 1000000

exec clean_schema.synonyms
exec clean_schema.tables
exec clean_schema.objects

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

CREATE OR REPLACE TYPE BODY publisher_obj
AS
   MEMBER PROCEDURE show_contact
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('CONTACT INFORMATION');
      DBMS_OUTPUT.put_line ('===================');
      DBMS_OUTPUT.put_line (SELF.pub_name);
      DBMS_OUTPUT.put_line (   SELF.contact_info.NAME.first_name
                            || ' '
                            || SELF.contact_info.NAME.last_name
                           );
      DBMS_OUTPUT.put_line (SELF.contact_info.address.address1);
      DBMS_OUTPUT.put_line (SELF.contact_info.address.city);
      DBMS_OUTPUT.put_line (SELF.contact_info.address.state);
      DBMS_OUTPUT.put_line (SELF.contact_info.phone);
      RETURN;
   END show_contact;
END;
/

-- Create the object table based on publisher_obj
CREATE TABLE publisher_tbl OF publisher_obj;

-- To test
/*
* 
* DECLARE
*    v_person      person_obj    := person_obj ('Ron', 'Hardman');
*    v_address     address_obj
*                        := address_obj ('123 Ora Way', NULL, 'Colorado Springs', 'CO');
*    v_contact     contact_obj := contact_obj (v_person, v_address, 5555555555);
*    v_publisher   publisher_obj := publisher_obj ('Oracle Press', v_contact);
* BEGIN
*   v_publisher.show_contact;
* END;
* /
* 
*/


/*
 * SECTION 2: This section demonstrates inheritance
 */

PROMPT
PROMPT *** Creating type discount_price_obj ***
PROMPT
PROMPT *** Discount_price_obj becomes the datatype of the price
PROMPT *** attribute in the inventory_obj object type.
PROMPT

-- discount_price_obj specification

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

/*******************************************************
* 
* Run the following to test the discount_price_obj type
*
* DECLARE
*    v_price discount_price_obj := discount_price_obj(.1, 75.00);
* BEGIN
*    dbms_output.put_line(v_price.discount_price);
* END;
* /
* 
*******************************************************/


PROMPT *** Creating type inventory_obj ***
PROMPT
PROMPT *** Inventory_obj is a complex object type that
PROMPT *** uses discount_price_obj as a datatype for
PROMPT *** the price attribute.  We also create it to
PROMPT *** be a base object type that can be instantiated.
PROMPT

-- inventory_obj specification

CREATE OR REPLACE TYPE inventory_obj AS OBJECT (
   item_id          NUMBER (10),
   num_in_stock     NUMBER (10),
   reorder_status   VARCHAR2 (20 CHAR),
   price            NUMBER (10, 2),
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

-- Use the following to test the inventory_obj object
/*
*
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
*/

PROMPT *** Creating type book_obj ***
PROMPT
PROMPT *** Book_obj is a subtype to inventory_obj.
PROMPT

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
/*
*
* DECLARE
*    v_book book_obj := book_obj (3124, 15, 39.99, '72121203', 'Oracle DBA 101', 563);
* BEGIN
*    v_book.print_book_information;
*    DBMS_OUTPUT.put_line ('	');
*    v_book.print_price;
* END;
* /
*
*/

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

CREATE OR REPLACE TYPE cd_obj
UNDER music_obj (
   title           VARCHAR2 (50 CHAR),
   date_released   DATE,
   CONSTRUCTOR FUNCTION cd_obj (
      artist          music_person_obj,
      title           VARCHAR2,
      date_released   DATE
   )
      RETURN SELF AS RESULT,
   MEMBER PROCEDURE show_cd
)
FINAL INSTANTIABLE;
/

CREATE OR REPLACE TYPE BODY cd_obj
AS
   CONSTRUCTOR FUNCTION cd_obj (
      artist          music_person_obj,
      title           VARCHAR2,
      date_released   DATE
   )
      RETURN SELF AS RESULT
   IS
   BEGIN
      SELF.artist := artist;
      SELF.title := title;
      SELF.date_released := date_released;
      RETURN;
   END cd_obj;
   MEMBER PROCEDURE show_cd
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('MUSIC TITLES IN BOOKSTORE1');
      DBMS_OUTPUT.put_line ('==========================');
      DBMS_OUTPUT.put_line ('TITLE: ' || SELF.title);
      DBMS_OUTPUT.put_line (   'ARTIST: '
                            || SELF.artist.first_name
                            || ' '
                            || SELF.artist.last_name
                           );
      DBMS_OUTPUT.put_line ('DATE RELEASED: ' || SELF.date_released);
   END show_cd;
END;
/

/*
 *
 * Now the object types are created.  We will create the persistent
 *  objects including an object table and object view.
 *
 */

CREATE TABLE book_tbl OF book_obj;

INSERT INTO book_tbl
     VALUES (2, 13, 'IN STOCK', 54.95, '72121203', 'TECHNICAL',
             'Oracle DBA 101', 563,
             publisher_obj ('Oracle Press',
                            contact_obj (person_obj ('Susan', 'Publisher'),
                                         address_obj ('123 Street',
                                                      'Suite 2',
                                                      'My City',
                                                      'CO'
                                                     ),
                                         '5555555555'
                                        )
                           ));

/*
 *
 * Create the book view
 *
 */

CREATE VIEW book_vie
   OF book_obj
   WITH OBJECT IDENTIFIER (item_id)
AS
   SELECT item_id, num_in_stock, reorder_status, price, isbn, CATEGORY, title,
          num_pages, publisher
     FROM book_tbl;

/*
 *
 * Test the view with a simple select
 *
 */

SELECT b.item_id, b.reorder_status, b.price,
       b.publisher.contact_info.NAME.first_name
  FROM book_vie b;

/*
 *
 * Describe the view
 *
 */
SET DESC DEPTH ALL
DESC book_vie

/*
 *
 * If we try a simple alteration to add an attribute to inventory_obj
 *  at this point, we must specify cascade.
 *
 * SQL> ALTER TYPE inventory_obj
 *   2  ADD ATTRIBUTE location VARCHAR2(100 CHAR);
 *  ALTER TYPE inventory_obj
 *
 *  ERROR at line 1:
 *  ORA-22312: must specify either CASCADE or INVALIDATE option
 *
 */

/*
 *
 * Alter the inventory_obj object type including CASCADE.
 *
 */

ALTER TYPE inventory_obj
  ADD ATTRIBUTE LOCATION VARCHAR2(100 CHAR) CASCADE;


/*
 *
 * Desribing the book_obj type, book_tbl table, and book_vie object view
 *
 */

PROMPT
PROMPT
PROMPT DESC book_obj may error, depending on the client cache 
PROMPT =======================================================
DESC book_obj 

PROMPT
PROMPT DESC book_table will show the table structure
PROMPT =============================================
DESC book_tbl

PROMPT 
PROMPT DESC book_vie will error because of the change to book_obj
PROMPT ==========================================================
DESC book_vie