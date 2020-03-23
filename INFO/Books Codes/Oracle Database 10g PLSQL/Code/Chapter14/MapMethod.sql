/*
 * MapMethod.sql
 * Chapter 14, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, Scott Urman
 *
 * This script demonstrates the map method.
 */

exec clean_schema.synonyms
exec clean_schema.tables
exec clean_schema.objects

CREATE OR REPLACE TYPE book_obj AS OBJECT (
   isbn        CHAR (10),
   title       VARCHAR2 (100),
   num_pages   NUMBER,
   MAP MEMBER FUNCTION return_isbn
      RETURN CHAR
);
/

CREATE OR REPLACE TYPE BODY book_obj
AS
   MAP MEMBER FUNCTION return_isbn
      RETURN CHAR
   IS
   BEGIN
      RETURN SELF.isbn;
   END return_isbn;
END;
/

/******************************************************
*
* Run the following to test: 
*      mapMethod.sql
*
* SET SERVEROUTPUT ON SIZE 1000000
*
* DECLARE
*    v_book1   book := book ('72121203', 'Oracle DBA 101', 563);
*    v_book2   book := book ('72122048', 'Oracle 8i: A Beginner''s Guide', 765);
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
