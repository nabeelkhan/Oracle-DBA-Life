/*
 * UserDefined.sql
 * Chapter 7, Oracle10g PL/SQL Programming 
 * by Ron Hardman, Mike McLaughlin, and Scott Urman
 * 
 * This script demonstrates user defined exceptions.
 */
 
DECLARE
  -- Exception to indicate an error condition
  e_DuplicateAuthors EXCEPTION;

  -- IDs for three authors
  v_Author1 books.author1%TYPE;
  v_Author2 books.author2%TYPE;
  v_Author3 books.author3%TYPE;
BEGIN
  /* Find the IDs for the 3 authors of 'Oracle9i DBA 101' */
  SELECT author1, author2, author3
    INTO v_Author1, v_Author2, v_Author3
    FROM books
    WHERE title = 'Oracle9i DBA 101';
  
  /* Ensure that there are no duplicates */
  IF (v_Author1 = v_Author2) OR (v_Author1 = v_Author3) OR
     (v_Author2 = v_Author3) THEN
     RAISE e_DuplicateAuthors;
  END IF;
END;
/

DECLARE
  -- Exception to indicate an error condition
  e_DuplicateAuthors EXCEPTION;

  -- IDs for three authors
  v_Author1 books.author1%TYPE;
  v_Author2 books.author2%TYPE;
  v_Author3 books.author3%TYPE;
BEGIN
  /* Find the IDs for the 3 authors of 'Oracle9i DBA 101' */
  SELECT author1, author2, author3
    INTO v_Author1, v_Author2, v_Author3
    FROM books
    WHERE title = 'Oracle9i DBA 101';
  
  /* Ensure that there are no duplicates */
  IF (v_Author1 = v_Author2) OR (v_Author1 = v_Author3) OR
     (v_Author2 = v_Author3) THEN
     RAISE e_DuplicateAuthors;
  END IF;
EXCEPTION
  WHEN e_DuplicateAuthors THEN
    /* Handler which executes when there are duplicate authors for
       Oracle9i DBA 101.  We will insert a log message recording 
       what has happened. */
    INSERT INTO log_table (info)
      VALUES ('Oracle9i DBA 101 has duplicate authors');
END;
/

DECLARE
  -- Exception to indicate an error condition
  e_DuplicateAuthors EXCEPTION;

  -- IDs for three authors
  v_Author1 books.author1%TYPE;
  v_Author2 books.author2%TYPE;
  v_Author3 books.author3%TYPE;
BEGIN
  /* Find the IDs for the 3 authors of 'Oracle9i DBA 101' */
  SELECT author1, author2, author3
    INTO v_Author1, v_Author2, v_Author3
    FROM books
    WHERE title = 'Oracle9i DBA 101';
  
  /* Ensure that there are no duplicates */
  IF (v_Author1 = v_Author2) OR (v_Author1 = v_Author3) OR
     (v_Author2 = v_Author3) THEN
     RAISE e_DuplicateAuthors;
  END IF;
EXCEPTION
  WHEN e_DuplicateAuthors THEN
    /* Handler which executes when there are duplicate authors for
       Oracle9i DBA 101.  We will insert a log message recording 
       what has happened. */
    INSERT INTO log_table (info)
      VALUES ('Oracle9i DBA 101 has duplicate authors');
  WHEN OTHERS THEN
    /* Handler which executes for all other errors. */
    INSERT INTO log_table (info) VALUES ('Another error occurred');
END;
/

DECLARE
  -- Exception to indicate an error condition
  e_DuplicateAuthors EXCEPTION;

  -- IDs for three authors
  v_Author1 books.author1%TYPE;
  v_Author2 books.author2%TYPE;
  v_Author3 books.author3%TYPE;
  
  -- Code and text of other runtime errors
  v_ErrorCode log_table.code%TYPE;
  v_ErrorText log_table.message%TYPE;
BEGIN
  /* Find the IDs for the 3 authors of 'Oracle9i DBA 101' */
  SELECT author1, author2, author3
    INTO v_Author1, v_Author2, v_Author3
    FROM books
    WHERE title = 'Oracle9i DBA 101';
  
  /* Ensure that there are no duplicates */
  IF (v_Author1 = v_Author2) OR (v_Author1 = v_Author3) OR
     (v_Author2 = v_Author3) THEN
     RAISE e_DuplicateAuthors;
  END IF;
EXCEPTION
  WHEN e_DuplicateAuthors THEN
    /* Handler which executes when there are duplicate authors for
       Oracle9i DBA 101.  We will insert a log message recording 
       what has happened. */
    INSERT INTO log_table (info)
      VALUES ('Oracle9i DBA 101 has duplicate authors');
  WHEN OTHERS THEN
    /* Handler which executes for all other errors. */
    v_ErrorCode := SQLCODE;
    -- Note the use of SUBSTR here.
    v_ErrorText := SUBSTR(SQLERRM, 1, 200);
    INSERT INTO log_table (code, message, info) VALUES
      (v_ErrorCode, v_ErrorText, 'Oracle error occurred');
END;
/

DECLARE
  -- Exception to indicate an error condition
  e_DuplicateAuthors EXCEPTION;

  -- IDs for three authors
  v_Author1 books.author1%TYPE;
  v_Author2 books.author2%TYPE;
  v_Author3 books.author3%TYPE;
  
BEGIN
  /* Find the IDs for the 3 authors of 'Oracle9i DBA 101' */
  SELECT author1, author2, author3
    INTO v_Author1, v_Author2, v_Author3
    FROM books
    WHERE title = 'Oracle9i DBA 101';
  
  /* Ensure that there are no duplicates */
  IF (v_Author1 = v_Author2) OR (v_Author1 = v_Author3) OR
     (v_Author2 = v_Author3) THEN
     RAISE e_DuplicateAuthors;
  END IF;
EXCEPTION
  WHEN e_DuplicateAuthors THEN
    /* Handler which executes when there are duplicate authors for
       Oracle9i DBA 101.  We will insert a log message recording 
       what has happened. */
    INSERT INTO log_table (info)
      VALUES ('Oracle9i DBA 101 has duplicate authors');
  WHEN OTHERS THEN
    INSERT INTO log_table (code, message, info) VALUES
      (NULL, SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK, 1, 200),
      'Oracle error occurred');
END;
/