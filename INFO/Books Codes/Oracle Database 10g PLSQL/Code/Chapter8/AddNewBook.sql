/*
 * AddNewBook.sql
 * Chapter 8, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This procedure will insert a new book into the books table.
 * It also demonstrates default parameters.
 */
 
CREATE OR REPLACE PROCEDURE AddNewBook(
  p_ISBN IN books.ISBN%TYPE,
  p_Category IN books.category%TYPE := 'Oracle Server',
  p_Title IN books.title%TYPE,
  p_NumPages IN books.num_pages%TYPE,
  p_Price IN books.price%TYPE,
  p_Copyright IN books.copyright%TYPE DEFAULT
    TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),
  p_Author1 IN books.author1%TYPE,
  p_Author2 IN books.author2%TYPE := NULL,
  p_Author3 IN books.author3%TYPE := NULL) AS
  
BEGIN
  -- Insert a new row into the table using the supplied
  -- parameters.
  INSERT INTO books (isbn, category, title, num_pages, price,
                     copyright, author1, author2, author3)
  VALUES (p_ISBN, p_Category, p_Title, p_NumPages, p_Price,
          p_Copyright, p_Author1, p_Author2, p_Author3);
END AddNewBook;
/

-- We can avoid passing author2 and author3 since they have
-- default values:
BEGIN
  AddNewBook('0000000000', 'Oracle Basics', 'A Really Nifty Book',
             500, 34.99, 2004, 1);
END;
/

ROLLBACK;

-- The same example, using named notation:
BEGIN
  AddNewBook(p_ISBN => '0000000000',
             p_Category => 'Oracle Basics',
             p_Title => 'A Really Nifty Book',
             p_NumPages => 500,
             p_Price => 34.99,
             p_Copyright => 2004,
             p_Author1 => 1);
END;
/

ROLLBACK;

-- Using all the default values:
BEGIN
  AddNewBook(p_ISBN => '0000000000',
             p_Title => 'A Really Nifty Book',
             p_NumPages => 500,
             p_Price => 34.99,
             p_Author1 => 1);
END;
/

ROLLBACK;
