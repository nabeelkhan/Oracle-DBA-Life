/*
 * VerifyAuthors.sql
 * Chapter 7, Oracle10g PL/SQL Programming
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 *
 * This procedure demonstrates the use of RAISE_APPLICATION_ERROR.
 */
 

/* Verifies that the authors passed in are valid for a book to be
   added to the inventory.  Errors are raised in the following situations:
     * author1 is null
     * any author does not exist in the authors table
     * there are author duplicates
   If the authors are valid, then the procedure completes without
   error. */
CREATE OR REPLACE PROCEDURE VerifyAuthors(
  p_Author1 IN books.author1%TYPE,
  p_Author2 IN books.author2%TYPE,
  p_Author3 IN books.author3%TYPE) AS

  v_AuthorCount NUMBER;
BEGIN
  /* First verify that each author is in the authors table */
  IF p_Author1 IS NULL THEN
    RAISE_APPLICATION_ERROR(-20000, 'Author1 cannot be null');
  ELSE
    SELECT COUNT(*)
      INTO v_AuthorCount
      FROM authors
      WHERE id = p_Author1;
    IF v_AuthorCount = 0 THEN
      RAISE_APPLICATION_ERROR(-20001,
        'Author1 ' || p_Author1 || ' does not exist');
    END IF;
  END IF;

  IF p_Author2 IS NOT NULL THEN
    SELECT COUNT(*)
      INTO v_AuthorCount
      FROM authors
      WHERE id = p_Author2;
    IF v_AuthorCount = 0 THEN
      RAISE_APPLICATION_ERROR(-20001,
        'Author2 ' || p_Author2 || ' does not exist');
    END IF;
  END IF;

  IF p_Author3 IS NOT NULL THEN
    SELECT COUNT(*)
      INTO v_AuthorCount
      FROM authors
      WHERE id = p_Author3;
    IF v_AuthorCount = 0 THEN
      RAISE_APPLICATION_ERROR(-20001,
        'Author3 ' || p_Author3 || ' does not exist');
    END IF;
  END IF;
  
  /* Now verify that there are no duplicate authors.  */
  IF p_Author1 = p_Author2 THEN
    RAISE_APPLICATION_ERROR (-20002,
      'Author1 ' || p_Author1 || ' and author2 ' || p_Author2 ||
      ' are duplicates');
  ELSIF p_Author1 = p_Author3 THEN
    RAISE_APPLICATION_ERROR (-20002,
      'Author1 ' || p_Author1 || ' and author3 ' || p_Author3 ||
      ' are duplicates');
  ELSIF p_Author2 = p_Author3 THEN
    RAISE_APPLICATION_ERROR (-20002,
      'Author2 ' || p_Author2 || ' and author3 ' || p_Author3 ||
      ' are duplicates');
  END IF;  
END VerifyAuthors;
/

-- The first three calls will raise errors
BEGIN VerifyAuthors(NULL, NULL, NULL); END;
/
BEGIN VerifyAuthors(30, 40, NULL); END;
/
BEGIN VerifyAuthors(30, 30, 1); END;
/

-- But these calls are successful
BEGIN VerifyAuthors(30, NULL, NULL); END;
/
BEGIN VerifyAuthors(30, 14, 8); END;
/

-- This block illustrates the behavior of a predefined exception
BEGIN
  RAISE NO_DATA_FOUND;
END;
/
