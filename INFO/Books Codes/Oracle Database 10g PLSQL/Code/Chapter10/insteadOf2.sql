/*
 * insteadOf2.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined triggers.
 */

SET ECHO ON

-- We can handle a simple insert case with the following trigger.
-- Note that this only handles one case, and does no error handling.
CREATE OR REPLACE TRIGGER InsertBooksAuthors
  INSTEAD OF INSERT ON books_authors
DECLARE

  v_Book books%ROWTYPE;
  v_AuthorID authors.id%TYPE;

BEGIN
  -- Figure out the ID of the new author
  BEGIN
    SELECT id
      INTO v_AuthorID
      FROM authors
      WHERE first_name = :new.first_name
        AND last_name = :new.last_name;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- No author found, create a new one
      INSERT INTO authors (id, first_name, last_name)
        VALUES (author_sequence.NEXTVAL, :new.first_name, :new.last_name)
        RETURNING ID INTO v_AuthorID;
  END;
  
  SELECT *
    INTO v_Book
    FROM books
    WHERE isbn = :new.isbn;
    
  -- Figure out whether the book already has 1 or 2 authors, and update 
  -- accordingly
  IF v_Book.author2 IS NULL THEN
    UPDATE books
      SET author2 = v_AuthorID
      WHERE isbn = :new.isbn;
  ELSE
    UPDATE books
      SET author3 = v_AuthorID
      WHERE isbn = :new.isbn;
  END IF;
END InsertBooksAuthors;
/
show errors

-- Now the INSERT should succeed
INSERT INTO books_authors (isbn, title, first_name, last_name)
  VALUES ('72230665', 'Oracle Database 10g PL/SQL Programming',
          'Joe', 'Blow');
          
