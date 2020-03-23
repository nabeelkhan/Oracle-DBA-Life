/*
 * TableFunctions.sql
 * Chapter 9, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined types.
 */

DROP FUNCTION SomeBooks;

DROP TYPE BookTypes;

DROP TYPE BookType;

CREATE TYPE BookType AS OBJECT (
  isbn  CHAR(10),
  title VARCHAR2(100)
)
/

CREATE TYPE BookTypes AS TABLE OF BookType;
/

CREATE OR REPLACE FUNCTION SomeBooks(p_Category IN books.category%TYPE)
  RETURN BookTypes AS

  v_ResultSet BookTypes := BookTypes();
  
  CURSOR c_SomeBooks IS
    SELECT isbn, title
      FROM books
      WHERE category = p_Category;

BEGIN
  FOR v_Rec IN c_SomeBooks LOOP
    
    v_ResultSet.EXTEND;
    v_ResultSet(v_ResultSet.LAST) := BookType(v_Rec.isbn, v_Rec.title);
  END LOOP;
  
  RETURN v_ResultSet;
END SomeBooks;
/
show errors

SELECT SomeBooks('Oracle Basics') FROM dual;

COLUMN title FORMAT a60

SELECT *
  FROM TABLE (SomeBooks('Oracle Basics'));


-- Since SomeBooks will always return the same output given the same
-- input, we can use the DETERMINISTIC keyword.
CREATE OR REPLACE FUNCTION SomeBooks(p_Category IN books.category%TYPE)
  RETURN BookTypes DETERMINISTIC AS

  v_ResultSet BookTypes := BookTypes();
  
  CURSOR c_SomeBooks IS
    SELECT isbn, title
      FROM books
      WHERE category = p_Category;

BEGIN
  FOR v_Rec IN c_SomeBooks LOOP
    
    v_ResultSet.EXTEND;
    v_ResultSet(v_ResultSet.LAST) := BookType(v_Rec.isbn, v_Rec.title);
  END LOOP;
  
  RETURN v_ResultSet;
END SomeBooks;
/
