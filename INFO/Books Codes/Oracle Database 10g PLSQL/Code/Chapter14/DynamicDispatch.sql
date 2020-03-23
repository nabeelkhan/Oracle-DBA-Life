/*
 * DynamicDispatch.sql
 * Chapter 14, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates dynamic dispatch/dynamic polymorphism
 */

exec clean_schema.synonyms
exec clean_schema.tables
exec clean_schema.objects

CREATE OR REPLACE TYPE abbrev_inventory_obj AS OBJECT (
   item_id   NUMBER (10),
   price     NUMBER (10, 2),
   MEMBER PROCEDURE print_price
)
NOT FINAL INSTANTIABLE;
/

CREATE OR REPLACE TYPE BODY abbrev_inventory_obj
AS
   MEMBER PROCEDURE print_price
   IS
      v_price   NUMBER := SELF.price * .80;
   BEGIN
      DBMS_OUTPUT.put_line ('Wholesale Cost: ' || v_price);
   END print_price;
END;
/

CREATE OR REPLACE TYPE abbrev_book_obj
UNDER abbrev_inventory_obj (
   isbn   VARCHAR2 (50),
   OVERRIDING MEMBER PROCEDURE print_price
)
FINAL INSTANTIABLE;
/

CREATE OR REPLACE TYPE BODY abbrev_book_obj
AS
   OVERRIDING MEMBER PROCEDURE print_price
   IS
   BEGIN
      DBMS_OUTPUT.put_line ('Retail Cost: ' || SELF.price);
   END print_price;
END;
/

/*******************************************************
* 
* SET SERVEROUTPUT ON SIZE 1000000
* DECLARE
*    v_wholesale   abbrev_inventory_obj := abbrev_inventory_obj (22, 54.95);
*    v_retail      abbrev_book_obj     := abbrev_book_obj (22, 54.95, 23022843);
* BEGIN
*    DBMS_OUTPUT.put_line ('SUBTYPE EXECUTION - FULL PRICE');
*    DBMS_OUTPUT.put_line ('==============================');
*    v_retail.print_price;
*    DBMS_OUTPUT.put_line ('	');
*    DBMS_OUTPUT.put_line ('BASE TYPE EXECUTION - REDUCED PRICE');
*    DBMS_OUTPUT.put_line ('===================================');
*    v_wholesale.print_price;
*    DBMS_OUTPUT.put_line ('	');
*    DBMS_OUTPUT.put_line ('EXAMPLE OF DYNAMIC DISPATCH');
*    DBMS_OUTPUT.put_line ('SUBTYPE METHOD RUN WHEN BASE TYPE IS EXECUTED');
*    DBMS_OUTPUT.put_line ('=============================================');
*    v_wholesale := v_retail;
*    v_wholesale.print_price;
* END;
* /
* 
*******************************************************/
