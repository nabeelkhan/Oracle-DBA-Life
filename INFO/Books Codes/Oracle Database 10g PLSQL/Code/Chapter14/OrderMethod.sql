/*
 * OrderMethod.sql
 * Chapter 14, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the order method.
 */

exec clean_schema.synonyms
exec clean_schema.tables
exec clean_schema.objects

CREATE OR REPLACE TYPE book_obj AS OBJECT (
   isbn        CHAR (10),
   title       VARCHAR2 (100),
   num_pages   NUMBER,
   ORDER MEMBER FUNCTION compare_book (p_isbn IN BOOK_OBJ)
      RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY book_obj
AS
   ORDER MEMBER FUNCTION compare_book (p_isbn IN BOOK_OBJ)
      RETURN NUMBER
   IS
   BEGIN
      IF p_isbn.isbn < SELF.isbn
      THEN
         RETURN 1;
      ELSIF p_isbn.isbn > SELF.isbn
      THEN
         RETURN -1;
      ELSE
         RETURN 0;
      END IF;
   END compare_book;
END;
/

/*******************************************************
* 
* Run the following to test: 
*      OrderMethod.sql
*
* SET SERVEROUTPUT ON SIZE 1000000
*
* DECLARE
*    v_book1   BOOK_OBJ := BOOK_OBJ ('72121203', 'Oracle DBA 101', 563);
*    v_book2   BOOK_OBJ := BOOK_OBJ ('72122048', 'Oracle 8i: A Beginner''s Guide', 765);
* BEGIN
*    IF v_book1 < v_book2
*    THEN
*       DBMS_OUTPUT.put_line (v_book1.title || ' < ' || v_book2.title);
*    ELSIF v_book1 = v_book2
*    THEN
*       DBMS_OUTPUT.put_line (v_book1.title || ' = ' || v_book2.title);
*    ELSE
*       DBMS_OUTPUT.put_line (v_book1.title || ' > ' || v_book2.title);
*    END IF;
* END;
* /
* 
*******************************************************/
