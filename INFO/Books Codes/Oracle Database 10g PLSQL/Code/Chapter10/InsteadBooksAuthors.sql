/*
 * InsteadBooksAuthors.sql
 * Chapter 10, Oracle10g PL/SQL Programming
 * by Ron Hardman, Michael McLaughlin and Scott Urman
 *
 * This script demonstrates user defined triggers.
 */

SET ECHO ON

-- Drop other triggers first, from previous examples.
DROP TRIGGER InsertBooksAuthors;
DROP TRIGGER GenerateAuthorID;

-- (Re)create the view if necessary
CREATE OR REPLACE VIEW books_authors AS
  SELECT b.isbn, b.title, a.first_name, a.last_name
    FROM books b, authors a
    WHERE b.author1 = a.id
       OR b.author2 = a.id
       OR b.author3 = a.id;

CREATE OR REPLACE TRIGGER InsteadBooksAuthors
  INSTEAD OF INSERT OR UPDATE OR DELETE ON books_authors
  FOR EACH ROW
DECLARE

  v_Book books%ROWTYPE;
  v_NewAuthorID authors.ID%TYPE;
  v_OldAuthorID authors.ID%TYPE;
  
  -- Local function which returns the ID of the new authors.
  -- If the first and last name do not exist in authors
  -- then a new ID is generated from author_sequence.
  FUNCTION getID(p_FirstName IN authors.first_name%TYPE,
                 p_LastName IN authors.last_name%TYPE)
    RETURN authors.ID%TYPE IS

    v_AuthorID authors.ID%TYPE;
  BEGIN
    -- Make sure that first and last name are both specified
    IF p_FirstName IS NULL or p_LastName IS NULL THEN
      RAISE_APPLICATION_ERROR(-20004,
        'Both first and last name must be specified');
    END IF;
    
    -- Use a nested block to trap the NO_DATA_FOUND exception
    BEGIN
      SELECT id
        INTO v_AuthorID
        FROM authors
        WHERE first_name = p_FirstName
          AND last_name = p_LastName;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        -- No author found, create a new one
        INSERT INTO authors (id, first_name, last_name)
          VALUES (author_sequence.NEXTVAL, p_FirstName, p_LastName)
            RETURNING ID INTO v_AuthorID;
    END getID;

      -- Now v_AuthorID contains the correct ID and we can return it.
      RETURN v_AuthorID;
    END getID;

  -- Local function which returns the row identified by either
  -- ISBN or title.  
  FUNCTION getBook(p_ISBN IN books.ISBN%TYPE,
                   p_Title IN books.title%TYPE)
    RETURN books%ROWTYPE IS
    
    v_Book books%ROWTYPE;
  BEGIN
    -- Ensure that at least one of isbn or title is supplied
    IF p_ISBN IS NULL AND p_Title IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001,
        'Either ISBN or title must be specified');
    ELSIF p_ISBN IS NOT NULL AND p_Title IS NOT NULL THEN
      -- Both specified, so use both title and ISBN in query
      SELECT *
        INTO v_Book
        FROM books
        WHERE isbn = p_ISBN
          AND title = p_Title;  
    ELSE
      -- Only one specified, so use either title or ISBN in query
      SELECT *
        INTO v_Book
        FROM books
        WHERE isbn = p_ISBN
           OR title = p_Title;  
    END IF;
    
    RETURN v_Book;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20002,
        'Could not find book with supplied ISBN/title');
    WHEN TOO_MANY_ROWS THEN
      RAISE_APPLICATION_ERROR(-20003,
        'ISBN/title must match a single book');
  END getBook;


BEGIN  /* Start of main trigger body */
  IF INSERTING THEN
    -- Get the book and author info
    v_Book := getBook(:new.ISBN, :new.title);
    v_NewAuthorID := getID(:new.first_name, :new.last_name);

    -- Ensure there are no duplicates
    IF v_Book.author1 = v_NewAuthorID OR
       v_Book.author2 = v_NewAuthorID THEN
      RAISE_APPLICATION_ERROR(-20006,
        'Cannot have duplicate authors');
    END IF;
    
    -- Figure out whether the book already has 1 or 2 authors, and
    -- update accordingly
    IF v_Book.author2 IS NULL THEN
      UPDATE books
        SET author2 = v_NewAuthorID
        WHERE ISBN = v_Book.ISBN;
    ELSIF v_Book.author3 IS NULL THEN
      UPDATE books
        SET author3 = v_NewAuthorID
        WHERE ISBN = v_Book.ISBN;
    ELSE
      -- Too many authors, cannot insert
      RAISE_APPLICATION_ERROR(-20005,
        v_Book.title || ' already has 3 authors');      
    END IF;

  ELSIF UPDATING THEN
    -- First check to ensure that the ISBN or title fields are not
    -- modified.
    IF (:new.ISBN != :old.ISBN OR
                     :new.title != :old.title) THEN
      RAISE_APPLICATION_ERROR(-20007,
        'Cannot modify ISBN or title in books_authors');
    END IF;
    
    -- Get the book and author info
    v_Book := getBook(:new.ISBN, :new.title);
    v_NewAuthorID := getID(:new.first_name, :new.last_name);
    v_OldAuthorID := getID(:old.first_name, :old.last_name);

    -- Figure out which of author1, author2, or author3 to modify
    -- and update accordingly
    IF v_Book.author1 = v_OldAuthorID THEN
      UPDATE books
        SET author1 = v_NewAuthorID
        WHERE ISBN = v_Book.ISBN;
    ELSIF v_Book.author2 = v_OldAuthorID THEN
      UPDATE books
        SET author2 = v_NewAuthorID
        WHERE ISBN = v_Book.ISBN;
    ELSE
      UPDATE BOOKS
        SET author3 = v_NewAuthorID
        WHERE ISBN = v_Book.ISBN;
    END IF;
  ELSE
    -- Get the book and author info
    v_Book := getBook(:old.ISBN, :old.title);
    v_OldAuthorID := getID(:old.first_name, :old.last_name);
    
    -- Figure out which of author1, author2, or author3 to modify
    -- and update accordingly.  Note that if this results in 
    -- all authors being removed from the table the NOT NULL
    -- constraint on author1 will raise an error.
    IF v_Book.author1 = v_OldAuthorID THEN
      -- Set author1 = author2, author2 = author3
      v_Book.Author1 := v_Book.Author2;
      v_Book.Author2 := v_Book.Author3;
    ELSIF v_Book.author2 = v_OldAuthorID THEN
      -- Set author2 = author 3
      v_Book.Author2 := v_Book.Author3;
    ELSE
      -- Clear author3
      v_Book.Author3 := NULL;
    END IF;
    
    UPDATE BOOKS
      SET author1 = v_Book.Author1,
          author2 = v_Book.Author2,
          author3 = v_Book.Author3
        WHERE ISBN = v_Book.ISBN;
  END IF;
  
END InsteadBooksAuthors;
/
show errors

-- This should raise an error
INSERT INTO books_authors (first_name, last_name)
  VALUES ('Dorthy', 'Doolitle');

-- This should also raise an error  
INSERT INTO books_authors(ISBN, title, first_name, last_name)
  VALUES ('72223855', 'Wrong title', 'Esther', 'Elegant');

-- This should succeed  
INSERT INTO books_authors(ISBN, title, first_name, last_name)
  VALUES ('72223855', 'Oracle 9i New Features', 'Esther', 'Elegant');

-- This should fail, since there are now two authors
UPDATE books_authors
  SET first_name = 'Rose', last_name = 'Riznit'
  WHERE ISBN = '72223855';

-- But this should be fine
UPDATE books_authors
  SET first_name = 'Rose', last_name = 'Riznit'
  WHERE ISBN = '72223855'
  AND last_name = 'Elegant';
  
-- This should succeed
DELETE FROM books_authors
  WHERE ISBN = '72223855'
  AND last_name = 'Riznit';
  
-- This should fail
DELETE FROM books_authors
  WHERE ISBN = '72223855';
