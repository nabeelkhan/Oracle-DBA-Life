/*
 * ThreeAuthors.sql
 * Chapter 8, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This script demonstrates a function and how to call it.
 */
 
CREATE OR REPLACE FUNCTION ThreeAuthors(p_ISBN IN books.isbn%TYPE)
  RETURN BOOLEAN AS

  v_Author3 books.author3%TYPE;
BEGIN
  -- Select the third author for the supplied book into v_Author3.
  SELECT author3
    INTO v_Author3
    FROM books
    WHERE isbn = p_ISBN;

  -- If v_Author3 is NULL, that means that the book has less then 3
  -- authors, so we can return false.  Otherwise, return true.
  IF v_Author3 IS NULL THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
  END IF;
END ThreeAuthors;
/

set serveroutput on

BEGIN
  FOR v_Rec IN (SELECT ISBN, title FROM books) LOOP
    IF ThreeAuthors(v_Rec.ISBN) THEN
      DBMS_OUTPUT.PUT_LINE('"' || v_Rec.title || '" has 3 authors');
    END IF;
  END LOOP;
END;
/
